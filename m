Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934607AbaFTPsH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:48:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47239 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933764AbaFTPsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:48:03 -0400
Message-ID: <1403279278.14743.64.camel@fourier>
Subject: Re: [PATCH] Makefile: version.h macros KERNEL_EXTRAVERSION,
 LINUX_EXTRAVERSION_CODE
From: Kamal Mostafa <kamal@canonical.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>,
        Luis Henriques <luis.henriques@canonical.com>
Date: Fri, 20 Jun 2014 08:47:58 -0700
In-Reply-To: <53A4016E.9040108@suse.cz>
References: <1403189058-24103-1-git-send-email-kamal@canonical.com>
	 <53A4016E.9040108@suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-06-20 at 11:39 +0200, Michal Marek wrote:
> Dne 19.6.2014 16:44, Kamal Mostafa napsal(a):
> > Adds new macro KERNEL_EXTRAVERSION(a,b,c,d) and value
> > LINUX_EXTRAVERSION_CODE to version.h, allowing ranged version checks of
> > extended-stable versions that use a numeric EXTRAVERSION value.
> > 
> > The new KERNEL_EXTRAVERSION(a,b,c,d) works like KERNEL_VERSION(a,b,c)...
> > If EXTRAVERSION is set to ".{integer}" (the common extended-stable kernel
> > version number scheme) then {integer} corresponds to KERNEL_EXTRAVERSION's
> > fourth arg.  If EXTRAVERSION is blank or a non-".{integer}" string like
> > "-rc5", that corresponds to a fourth parameter of 0.
> 
> Why don't you guys simply increment the third digit in the extended
> stable tree and get support for KERNEL_VERSION() for free? You always
> start after the respective stable branch has reached EOL, don't you?

Yes, we only start after the stable branch has reached EOL.

We don't increment the third integer for the extended-stable branches
(we add a fourth integer instead) in order to avoid the possibility of a
collision if Greg KH were to ever release a "special" post-EOL version
of one of his branches.

 -Kamal


