Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806Ab3FZR2U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 13:28:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52939 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841Ab3FZR2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 13:28:18 -0400
Date: Wed, 26 Jun 2013 10:28:17 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peng Tao <bergwolf@gmail.com>
Cc: "Dilger, Andreas" <andreas.dilger@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 07/11] staging/lustre: fix build error on non-x86
 platforms
Message-ID: <20130626172817.GB6842@kroah.com>
References: <1372119326-3565-1-git-send-email-bergwolf@gmail.com>
 <1372119326-3565-8-git-send-email-bergwolf@gmail.com>
 <20130625022244.GG18752@kroah.com>
 <CA+a=Yy6GD6xAG=qULGbwOA1wCt-seVtCv1tufGvmmO-jpbgL3A@mail.gmail.com>
 <220AF645-E299-4B35-9E15-858C7A10FF3E@intel.com>
 <20130625152003.GB20244@kroah.com>
 <CA+a=Yy48DH0q7-m8J0r-0oBGLbEBx5AwrBKCEb2pZ3AsPJg-Xw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+a=Yy48DH0q7-m8J0r-0oBGLbEBx5AwrBKCEb2pZ3AsPJg-Xw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 04:52:03PM +0800, Peng Tao wrote:
> Since it takes time to patch kernel's generic watchdog, can we get
> this patch in so that we have a build-able Lustre base, and then we
> can work on push necessary bits to kernel watchdog? I understand that
> we shouldn't reinvent things. Just don't want it to be a blocking
> issue for build and if we simply delete it, we lose a feature that is
> still missing in kernel watchdog.

Why not delete it, and then work on getting the feature into the
upstream watchdog?  Given that this stuff isn't going to be enabled
until 3.12 anyway, you have time, right?

Shortcuts aren't really allowed in upstream kernel development, you know
that :)

thanks,

greg k-h
