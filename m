Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247AbaFVVat (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 17:30:49 -0400
Received: from top.free-electrons.com ([176.31.233.9]:44857 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751493AbaFVVas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 17:30:48 -0400
Date: Sun, 22 Jun 2014 18:30:00 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guido =?iso-8859-1?Q?Mart=EDnez?= <guido@vanguardiasur.com.ar>
Subject: Re: [PATCH] init: Introduce 'noinitramfs' kernel parameter
Message-ID: <20140622212959.GA766@arch.cereza>
References: <1403415685-21455-1-git-send-email-ezequiel@vanguardiasur.com.ar>
 <20140622145329.GA19936@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140622145329.GA19936@khazad-dum.debian.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrique,

On 22 Jun 11:53 AM, Henrique de Moraes Holschuh wrote:
> On Sun, 22 Jun 2014, Ezequiel Garcia wrote:
> > This commit adds a new kernel parameter to provide such option, following the
> > naming of the current 'initrd' which serves a similar purpose, for an initial
> > RAM disk.
> 
> How does it interact with the early initramfs?
> 
> Maybe we should have the options to ignore both, ignore just the early
> initramfs (to skip microcode updates and ACPI table updates), and ignore
> just the main initramfs?
> 

I must admit I don't have much experience with any "earlier" initramfs.
Maybe you can point me at some links about this?

Unless I'm missing something, this "early" initramfs is an userspace artifact
in the construction of the initramfs, so the kernel has no way to distinguish
one from the other. Thus, we cannot mount one and not the other.
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
