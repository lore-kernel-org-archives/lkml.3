Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520AbaEFMmk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 08:42:40 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:31768 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757505AbaEFMmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 08:42:36 -0400
Date: Tue, 6 May 2014 15:41:57 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, devel@acpica.org,
        kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>,
        Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Robert Moore <robert.moore@intel.com>, Lv Zheng <lv.zheng@intel.com>
Subject: Re: [patch] lib: check for strcpy() overflows to fixed length buffers
Message-ID: <20140506124157.GT4963@mwanda>
References: <20140430150844.GA10621@mwanda>
 <1507574.Y0KFKOdI6F@vostro.rjw.lan>
 <20140430201529.GX4963@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140430201529.GX4963@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 11:15:29PM +0300, Dan Carpenter wrote:
> > > diff --git a/include/acpi/platform/acenv.h b/include/acpi/platform/acenv.h
> > > index e863dd5..5e0fc2b 100644
> > > --- a/include/acpi/platform/acenv.h
> > > +++ b/include/acpi/platform/acenv.h
> > 
> > This is an ACPICA header and changes to it need to be submitted to the ACPICA
> > maintainers (as per MAINTAINERS).  We only get ACPICA changes from the
> > upstream project (except for really special situations).
> 
> Ok.  I should have added Robert and Lv to the CC list.  My guess is
> that the (void) is needed to avoid compile warnings but it's needed for
> us to avoid compile breakage with this change.
> 
> Anyway, I'll wait for a couple days and resend that bit broken out.
> 

In the end, I won't need to modify the ACPICA headers if I use an
expression statement ({ ... }) instead of a do { } while (0) statement.

Thanks, though.  :)

regards,
dan carpenter
