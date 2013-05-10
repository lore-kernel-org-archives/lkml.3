Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab3EJDkw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 23:40:52 -0400
Received: from mail-vb0-f48.google.com ([209.85.212.48]:58553 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198Ab3EJDkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 23:40:51 -0400
MIME-Version: 1.0
In-Reply-To: <CA+5PVA5V59N7CaX++=059icOH1-u6a4U+B46LijMn0eeB1UZFw@mail.gmail.com>
References: <CACtbSuSDBe33DGfR0LFXCtzRYBaF-JuKBjYWu8QFEdw7nENPSA@mail.gmail.com>
	<CA+5PVA5V59N7CaX++=059icOH1-u6a4U+B46LijMn0eeB1UZFw@mail.gmail.com>
Date: Thu, 9 May 2013 20:40:50 -0700
Message-ID: <CACtbSuTcLnkO0qM9o60nUerKGPdLUqxJxBbK2Gd0WYZtgcLMSg@mail.gmail.com>
Subject: Re: [PATCH] [SVN] Please Merge 7 VirtualBox Kernel Modules into the
 Linux Kernel
From: quickbooks office <quickbooks.office@gmail.com>
To: Josh Boyer <jwboyer@gmail.com>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        vbox-dev@virtualbox.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 8, 2013 at 8:40 AM, Josh Boyer <jwboyer@gmail.com> wrote:
> On Wed, May 8, 2013 at 12:09 AM, quickbooks office
> <quickbooks.office@gmail.com> wrote:
>> Please Merge VirtualBox Kernel Modules into the Kernel.
>>
>> -----------------------------------------------------------------------------------------------------------
>>
>> svn co http://www.virtualbox.org/svn/vbox/trunk vbox
>> sh '/home/user/vbox/src/VBox/Additions/linux/export_modules'
>> VBoxGuestModules.tar.gz
>>
>> Extracting VBoxGuestModules.tar.gz will give the Source Code for 3
>> modules (used in a Linux Guest):
>>
>> 1. vboxguest (VirtualBox guest kernel module)
>>
>> 2. vboxsf (VirtualBox guest kernel module for shared folders)
>>
>> 3. vboxvideo (VirtualBox guest kernel module for drm support)
>
> That's not how this works.  The vbox developers need to submit them as
> patches to the appropriate maintainers and they need to go through
> proper review.  As far as I can tell, that hasn't been done because
> they don't want to settle on a single API/ABI between the kernel and
> userspace interfaces for vbox.
>
> josh

Who are the appropriate maintainers for adding new (VirtualBox) kernel
modules to the Linux kernel?
And how would they go through proper review?

Thanks.
