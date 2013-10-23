Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635Ab3JWQ71 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 12:59:27 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:44868 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961Ab3JWQ70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 12:59:26 -0400
Date: Wed, 23 Oct 2013 09:59:18 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: "Boie, Andrew P" <andrew.p.boie@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mmarek@suse.cz" <mmarek@suse.cz>
Subject: Re: [PATCH 1/1] x86: boot: support minigzip bzImage compression
Message-ID: <20131023165918.GC22394@roeck-us.net>
References: <1382476041-1115-1-git-send-email-andrew.p.boie@intel.com>
 <1382476041-1115-2-git-send-email-andrew.p.boie@intel.com>
 <e7a2d995-e90f-4912-a0b9-4cf5725b246b@email.android.com>
 <52673A1E.60005@roeck-us.net>
 <2E57EB624252DB47AFBC064A9AFBA98064B75AF3@ORSMSX104.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2E57EB624252DB47AFBC064A9AFBA98064B75AF3@ORSMSX104.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23, 2013 at 04:47:38PM +0000, Boie, Andrew P wrote:
> > From: Guenter Roeck [linux@roeck-us.net]
> > Or just change the build system to have /bin/gzip point to minigzip if so
> > desired. I have done the same to replace it with pigz.
> > Debian/Ubuntu provides the update-alternatives command for that
> > purpose. If that is not available, just hard-link it.
> 
> Android minigzip and gzip unfortunately don't have the same command line syntax. Before I wrote this patch I had a horrible hack in place involving a shell script named "gzip" that called minigzip internally.
> 
Why is that a horrible hack ? I think it is better than clogging
kernel makefiles with that kind of tools detail. Actually, you have
(at least) three other options: fix/update gzip, update minigzip
to match the gzip cli, or use a script to map one to the other.

Guenter
