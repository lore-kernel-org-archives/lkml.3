Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819Ab3JaMGt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 08:06:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55514 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638Ab3JaMGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 08:06:48 -0400
Date: Thu, 31 Oct 2013 05:08:50 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Lv Zheng <lv.zheng@intel.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Bob Moore <robert.moore@intel.com>
Subject: Re: [PATCH 0/4] ACPICA: Stable material of ACPI executer fixes for
 linux-3.8.
Message-ID: <20131031120850.GA17048@kroah.com>
References: <cover.1383181113.git.lv.zheng@intel.com>
 <2226874.g7cLvQ5SiE@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2226874.g7cLvQ5SiE@vostro.rjw.lan>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 31, 2013 at 12:39:21PM +0100, Rafael J. Wysocki wrote:
> On Thursday, October 31, 2013 09:07:40 AM Lv Zheng wrote:
> > There are bug-fixes for AML interpreter upstreamed, fixing some serious
> > issues found in recent platforms.  These fixes make Linux AML interpreter
> > more ACPI 2.0 ASL concept compliant.  Further AML interpreter fixes should
> > be based on such improvements, thus they are good materials for stable.
> > 
> > This patch set can be safely applied to linux-3.8:
> > commit 19f949f52599ba7c3f67a5897ac6be14bfcb1200 upstream.
> > 
> > The patch set has passed build/boot tests on the following machines:
> >   Dell Inspiron Mini 1010 (i386)
> >   HP Compaq 8200 Elite SFF PC (x86-64)
> > 
> > Bob Moore (4):
> >   ACPICA: Interpreter: Fix Store() when implicit conversion is not
> >     possible.
> >   ACPICA: DeRefOf operator: Update to fully resolve FieldUnit and
> >     BufferField refs.
> >   ACPICA: Return error if DerefOf resolves to a null package element.
> >   ACPICA: Fix for a Store->ArgX when ArgX contains a reference to a
> >     field.
> 
> Hi Greg,
> 
> Please take patches [1-4/4] for stable.

"Which" stable tree?

I don't do 3.8, it's long been end-of-life, although one company is
trying to keep it alive, but that's not me.

I'm only handling 3.4, 3.10, and 3.11 stable trees right now, which
one(s) should these be applied to?

thanks,

greg k-h
