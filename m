Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451AbaKVKIU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 05:08:20 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:45065 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbaKVKIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 05:08:19 -0500
MIME-Version: 1.0
In-Reply-To: <CANZNk81YTNVfY0U3LsugmGEmgooVKYqGtWZHCCmJ0whF_g+uyQ@mail.gmail.com>
References: <CANZNk81YTNVfY0U3LsugmGEmgooVKYqGtWZHCCmJ0whF_g+uyQ@mail.gmail.com>
Date: Sat, 22 Nov 2014 11:08:18 +0100
Message-ID: <CAOyooG10Pj=0Oer2LnYsGimrRXHEa+MgrEBQJEhN+fL+02SSCQ@mail.gmail.com>
Subject: Re: Your editor/IDE settings for autocompletion and other easiness
From: Oussama Jabbari <oussama.jabbari@gmail.com>
To: Andrey Utkin <andrey.krieger.utkin@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kernelnewbies <kernelnewbies@kernelnewbies.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 22, 2014 at 4:58 AM, Andrey Utkin
<andrey.krieger.utkin@gmail.com> wrote:
> (I was asked to research this topic to help students. So please ignore
> this topic if all you want to say is that it is OK to code in editor
> without autocompletion and any other integration, and that there's LXR
> website. We all know that.)
>
> Dear kernel developers,
> if you have a minute, please share
> - what's your configuration for editor integration with sources tree?
> (the opposite is "just using any editor")
> - which IDE/editor handiness options except autocompletion are
> possible to obtain while developing kernel code, and which options do
> you use?

Hi,

I already tried kernel drivers dev with Eclipse (it was quite helpful):
https://wiki.eclipse.org/HowTo_use_the_CDT_to_navigate_Linux_kernel_source

I also often use juste vim + cscope for searching the kernel:
make cscope
cscope -d


>
> If you don't use any special configuration, feel free not to reply.
>
> Thanks!
>
> --
> Andrey Utkin
>
> _______________________________________________
> Kernelnewbies mailing list
> Kernelnewbies@kernelnewbies.org
> http://lists.kernelnewbies.org/mailman/listinfo/kernelnewbies
