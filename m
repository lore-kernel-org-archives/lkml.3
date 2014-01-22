Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415AbaAVRlV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 12:41:21 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:50782 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311AbaAVRlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 12:41:17 -0500
MIME-Version: 1.0
In-Reply-To: <CAH=mFZwtOiTZvOd0_iezcYG+dL=mdxspECUmVeQq6e684sjKqg@mail.gmail.com>
References: <CAH=mFZwxay59O8sHc1fKSbh=gHPghYZMPNKEVyPvXUgitx1vPg@mail.gmail.com>
	<CAH=mFZzmcp5amS-JsNApWiwgYqs70M==FUA6KoxH+oLdbZihcg@mail.gmail.com>
	<CAK2H+ee8MgXdm3eTzrkvo=R-=8U_0LOmEAKMnKga8KU04jmgCg@mail.gmail.com>
	<CAH=mFZzLEQ5MAAmwB3tdcM+DxWQho9C6h1Ho7NhKe6JMnOhyVg@mail.gmail.com>
	<CAK2H+eeihXmxcaupmiXLLRbsbMKiaRT52sxWLX_p3EBFJVuiyA@mail.gmail.com>
	<CAH=mFZwtOiTZvOd0_iezcYG+dL=mdxspECUmVeQq6e684sjKqg@mail.gmail.com>
Date: Wed, 22 Jan 2014 09:41:16 -0800
Message-ID: <CAK2H+edXO3Akcv8jMuantrhd1UzyMZ3MUFkFXYGweS_fLbN_cw@mail.gmail.com>
Subject: Re: Help Needed
From: Mark Knecht <markknecht@gmail.com>
To: Madhusudhan Rao Sripalle <madhu.sripalle@gmail.com>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 7:47 AM, Madhusudhan Rao Sripalle
<madhu.sripalle@gmail.com> wrote:
> I have attached the boot directory contents, /boot/grub/grub.cfg and
> /etc/default/grub contents. Also attached the mount points on the
> system.
>
> On Wed, Jan 22, 2014 at 8:39 PM, Mark Knecht <markknecht@gmail.com> wrote:
>> On Wed, Jan 22, 2014 at 7:05 AM, Madhusudhan Rao Sripalle
>> <madhu.sripalle@gmail.com> wrote:
>>> The grub file is /boot/grub/grub.cfg. The newly built kernel is
>>> reflected in grub.cfg. But, the grub doesn't display this new kernel
>>> at the boot time. I tried few tips from the web. It is no help. That
>>> is why I sought help from this forum.
>>
>> You have not provided enough information for anyone to help you very
>> much. Show  things like the contents of /boot, your grub config file,
>> etc., and maybe we'll see the mistake you're making.
>>
>> Good luck,
>> Mark

I thin you need someone who knows your disto. You're likely going to
be better served on a distro-specific list.

In my case (Gentoo) the file edited to give me boot options is
/boot/grub/grub.conf which is not what you attached. I don't have the
file on my system but maybe your disto calls it something else.
Anyway, the contents of what you showed are quite different from the
way we do it on Gentoo. My grub.conf file contents for comparison:

c2RAID6 ~ # cat /boot/grub/grub.conf
default 0
timeout 15
splashimage=(hd0,0)/boot/grub/splash.xpm.gz


title RAID6 3.10.27-gentoo using LABEL (RAID6, md=1.2, initramfs in kernel)
root (hd0,0)
kernel (hd0,0)/boot/bzImage-3.10.27-gentoo root=LABEL=RAID6root
video=vesafb vga=0x307

title RAID6 3.10.26-gentoo using LABEL (RAID6, md=1.2, initramfs in kernel)
root (hd0,0)
kernel (hd0,0)/boot/bzImage-3.10.26-gentoo root=LABEL=RAID6root
video=vesafb vga=0x307


title SSD 3.8.13-gentoo using LABEL (SSD, no initramfs)
root (hd5,1)
kernel (hd5,0)/boot/bzImage-3.8.13-gentoo root=LABEL=SDDroot
video=vesafb vga=0x307

title SSD 3.8.13-gentoo using /dev/sda2 (SSD, no initramfs)
root (hd5,1)
kernel (hd5,0)/boot/bzImage-3.8.13-gentoo root=/dev/sda2 video=vesafb vga=0x307

c2RAID6 ~ #

When I build a new kernel it's just added in the manner I briefly
explained earlier.

Likely I cannot give more help.

Good luck,
Mark
