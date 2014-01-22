Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828AbaAVPFy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 10:05:54 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:38684 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754704AbaAVPFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 10:05:51 -0500
MIME-Version: 1.0
In-Reply-To: <CAK2H+ee8MgXdm3eTzrkvo=R-=8U_0LOmEAKMnKga8KU04jmgCg@mail.gmail.com>
References: <CAH=mFZwxay59O8sHc1fKSbh=gHPghYZMPNKEVyPvXUgitx1vPg@mail.gmail.com>
	<CAH=mFZzmcp5amS-JsNApWiwgYqs70M==FUA6KoxH+oLdbZihcg@mail.gmail.com>
	<CAK2H+ee8MgXdm3eTzrkvo=R-=8U_0LOmEAKMnKga8KU04jmgCg@mail.gmail.com>
Date: Wed, 22 Jan 2014 20:35:50 +0530
Message-ID: <CAH=mFZzLEQ5MAAmwB3tdcM+DxWQho9C6h1Ho7NhKe6JMnOhyVg@mail.gmail.com>
Subject: Re: Help Needed
From: Madhusudhan Rao Sripalle <madhu.sripalle@gmail.com>
To: Mark Knecht <markknecht@gmail.com>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The grub file is /boot/grub/grub.cfg. The newly built kernel is
reflected in grub.cfg. But, the grub doesn't display this new kernel
at the boot time. I tried few tips from the web. It is no help. That
is why I sought help from this forum.

On Wed, Jan 22, 2014 at 8:25 PM, Mark Knecht <markknecht@gmail.com> wrote:
> On Wed, Jan 22, 2014 at 6:34 AM, Madhusudhan Rao Sripalle
> <madhu.sripalle@gmail.com> wrote:
>> Thanks to Randy and Ryan for the responses. The pointers are really
>> helpful. Currently I am facing an issue with Ubuntu's grub not
>> displaying the newly built kernel.
>>
>> Existing kernel on the ubuntu system is 3.2.0-23-generic. While the
>> new one is 3.11.10. The Grub has/displays fedora and ubuntu each one
>> and their corresponding recovery modes. On building and installing
>> 3.11.10 on Ubuntu's, the newly built kernel doesn't show up in grub at
>> the boot time. Kindly help. Updating grub also doesn't help.
>>
>> -Madhu
>
> There are likely a lot of resources on the web to more complete
> instructions but roughly speaking:
>
> 1) Mount /boot
> 2) Copy your new kernel binary to /boot. I.e. cp
> arch/x86_64/boot/bzImage /boot/bzImage-#####
> 3) Edit /boot/grub/grub.conf to add the new kernel in the list of options
>
> HTH,
> Mark
