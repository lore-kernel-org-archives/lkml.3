Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779AbaKYXvL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 18:51:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52087 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbaKYXvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 18:51:09 -0500
Date: Tue, 25 Nov 2014 15:51:08 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Richard Weinberger <richard@nod.at>
Cc: x86@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        rafael.j.wysocki@intel.com, pebolle@tiscali.nl,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: defconfig: Enable CONFIG_FHANDLE
Message-ID: <20141125235108.GB3138@kroah.com>
References: <1416958612-7448-1-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416958612-7448-1-git-send-email-richard@nod.at>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 12:36:52AM +0100, Richard Weinberger wrote:
> systemd has a hard dependency on CONFIG_FHANDLE.

It's been this way for a very long time, why is this suddenly an issue?

And what about all of the other systemd kernel requirements, are you
ignoring them here?

> If you run systemd with CONFIG_FHANDLE=n it will somehow
> boot but fail to spawn a getty or other basic services.
> As systemd is now used by most x86 distributions it
> makes sense to enabled this by default and save kernel
> hackers a lot of value debugging time.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  arch/x86/configs/i386_defconfig   | 1 +
>  arch/x86/configs/x86_64_defconfig | 1 +

Do these files even make any sense anymore?  Who uses them?  The distros
sure do not...

greg k-h
