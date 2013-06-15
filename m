Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461Ab3FOR7i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 13:59:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52904 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351Ab3FOR7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 13:59:37 -0400
Date: Sat, 15 Jun 2013 11:00:14 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: xypron.glpk@gmx.de
Cc: eparis@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Enable fanotify API by default.
Message-ID: <20130615180014.GA30406@kroah.com>
References: <1371313047-17753-1-git-send-email-xypron.glpk@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371313047-17753-1-git-send-email-xypron.glpk@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 15, 2013 at 06:17:27PM +0200, xypron.glpk@gmx.de wrote:
> From: Heinrich Schuchardt <xypron.glpk@gmx.de>
> 
> The fanotify interface is the basis for on access malware detection
> in the Linux kernel. The development of a prior solution (DazukoFS)
> has been stopped therefore.
> 
> Both free (ClamAV) as well as commercial viurs scanners (Sophos
> Anti-Virus, AVG) using this interface exist.
> 
> Since kernel version 3.8.0 the implementationof the fanotify inter-
> face is errorfree enough to be used on a productive system.
> Personally I have been using it for virus scanning on multiple
> systems for several months without issues while a developing a
> wrapper around ClamAV, see
> https://github.com/xypron/skyldav
> 
> A large scale usage of the fanotify interface can only expected if
> the API is enabled by default.

We only set options to 'default Y' if they are needed in order to keep
your machine working properly.  Now that this option has been around for
a while, changing the default will not affect anyone's machines, as they
will not see that change.

Why not just work with the distros to enable fanotify, that's where you
need this enabled, not here.  Those are the majority of users, not
kernel developers who pick their own kernel configurations.

thanks,

greg k-h
