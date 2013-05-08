Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711Ab3EHPk4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 11:40:56 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:38356 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444Ab3EHPkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 11:40:55 -0400
MIME-Version: 1.0
In-Reply-To: <CACtbSuSDBe33DGfR0LFXCtzRYBaF-JuKBjYWu8QFEdw7nENPSA@mail.gmail.com>
References: <CACtbSuSDBe33DGfR0LFXCtzRYBaF-JuKBjYWu8QFEdw7nENPSA@mail.gmail.com>
Date: Wed, 8 May 2013 11:40:54 -0400
Message-ID: <CA+5PVA5V59N7CaX++=059icOH1-u6a4U+B46LijMn0eeB1UZFw@mail.gmail.com>
Subject: Re: [PATCH] [SVN] Please Merge 7 VirtualBox Kernel Modules into the
 Linux Kernel
From: Josh Boyer <jwboyer@gmail.com>
To: quickbooks office <quickbooks.office@gmail.com>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        vbox-dev@virtualbox.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 8, 2013 at 12:09 AM, quickbooks office
<quickbooks.office@gmail.com> wrote:
> Please Merge VirtualBox Kernel Modules into the Kernel.
>
> -----------------------------------------------------------------------------------------------------------
>
> svn co http://www.virtualbox.org/svn/vbox/trunk vbox
> sh '/home/user/vbox/src/VBox/Additions/linux/export_modules'
> VBoxGuestModules.tar.gz
>
> Extracting VBoxGuestModules.tar.gz will give the Source Code for 3
> modules (used in a Linux Guest):
>
> 1. vboxguest (VirtualBox guest kernel module)
>
> 2. vboxsf (VirtualBox guest kernel module for shared folders)
>
> 3. vboxvideo (VirtualBox guest kernel module for drm support)

That's not how this works.  The vbox developers need to submit them as
patches to the appropriate maintainers and they need to go through
proper review.  As far as I can tell, that hasn't been done because
they don't want to settle on a single API/ABI between the kernel and
userspace interfaces for vbox.

josh
