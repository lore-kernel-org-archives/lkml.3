Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955AbaAVPIl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 10:08:41 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:59025 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755342AbaAVPIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 10:08:40 -0500
MIME-Version: 1.0
In-Reply-To: <CAH=mFZzLEQ5MAAmwB3tdcM+DxWQho9C6h1Ho7NhKe6JMnOhyVg@mail.gmail.com>
References: <CAH=mFZwxay59O8sHc1fKSbh=gHPghYZMPNKEVyPvXUgitx1vPg@mail.gmail.com>
	<CAH=mFZzmcp5amS-JsNApWiwgYqs70M==FUA6KoxH+oLdbZihcg@mail.gmail.com>
	<CAK2H+ee8MgXdm3eTzrkvo=R-=8U_0LOmEAKMnKga8KU04jmgCg@mail.gmail.com>
	<CAH=mFZzLEQ5MAAmwB3tdcM+DxWQho9C6h1Ho7NhKe6JMnOhyVg@mail.gmail.com>
Date: Wed, 22 Jan 2014 16:08:40 +0100
Message-ID: <CAFLxGvxo_43FnEQcrX1tVsrgcEv3z9=rBjv116jTMzih0Va6_g@mail.gmail.com>
Subject: Re: Help Needed
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Madhusudhan Rao Sripalle <madhu.sripalle@gmail.com>
Cc: Mark Knecht <markknecht@gmail.com>,
        Linux Kernel List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 4:05 PM, Madhusudhan Rao Sripalle
<madhu.sripalle@gmail.com> wrote:
> The grub file is /boot/grub/grub.cfg. The newly built kernel is
> reflected in grub.cfg. But, the grub doesn't display this new kernel
> at the boot time. I tried few tips from the web. It is no help. That
> is why I sought help from this forum.

If "make install" does not work your distro's /sbin/installkernel is
broken and needs fixing.

> On Wed, Jan 22, 2014 at 8:25 PM, Mark Knecht <markknecht@gmail.com> wrote:
>> On Wed, Jan 22, 2014 at 6:34 AM, Madhusudhan Rao Sripalle
>> <madhu.sripalle@gmail.com> wrote:
>>> Thanks to Randy and Ryan for the responses. The pointers are really
>>> helpful. Currently I am facing an issue with Ubuntu's grub not
>>> displaying the newly built kernel.
>>>
>>> Existing kernel on the ubuntu system is 3.2.0-23-generic. While the
>>> new one is 3.11.10. The Grub has/displays fedora and ubuntu each one
>>> and their corresponding recovery modes. On building and installing
>>> 3.11.10 on Ubuntu's, the newly built kernel doesn't show up in grub at
>>> the boot time. Kindly help. Updating grub also doesn't help.
>>>
>>> -Madhu
>>
>> There are likely a lot of resources on the web to more complete
>> instructions but roughly speaking:
>>
>> 1) Mount /boot
>> 2) Copy your new kernel binary to /boot. I.e. cp
>> arch/x86_64/boot/bzImage /boot/bzImage-#####
>> 3) Edit /boot/grub/grub.conf to add the new kernel in the list of options
>>
>> HTH,
>> Mark
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Thanks,
//richard
