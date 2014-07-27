Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751397AbaG0FQe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 01:16:34 -0400
Received: from [167.88.47.89] ([167.88.47.89]:33330 "EHLO
	chapterhouse.mjoras.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750737AbaG0FQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 01:16:33 -0400
X-Greylist: delayed 529 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Jul 2014 01:16:32 EDT
Message-ID: <53D48919.6060407@mjoras.com>
Date: Sat, 26 Jul 2014 22:07:37 -0700
From: Matt Joras <dev@mjoras.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Nick Krause <xerofoify@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Bug on Kernel 3.16 r6: Sound and Buffering in Clementine with
 Files are Transferring to Music Directory
References: <CAPDOMViYi_rg_cGp_SgZVqX6pw+SB=CVbr1kFn5WG481s4tz5A@mail.gmail.com>
In-Reply-To: <CAPDOMViYi_rg_cGp_SgZVqX6pw+SB=CVbr1kFn5WG481s4tz5A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick,

I could be wrong but I doubt this is symptomatic of a "kernel bug" as 
you seem to think. Are you saying that the music stutters during a 
transfer operation to your external hard drive? I.e. the music playback 
in Clementine stutters while you are writing to the disk the music files 
are on? If so, that doesn't really sound like a bug to me, especially 
not a sound driver bug. That sounds like a pretty typical instance of IO 
waiting; i.e. the drive is busy and Clementine has to wait its turn to 
fill up its buffer again with data. Most of the time applications like 
that will let you increase their "buffer size" which is essentially just 
the amount of data the application will load at a time from the disk.

If that's not the situation you were describing, feel free to clarify.

Regards,
Matt Joras

On 07/26/2014 08:41 PM, Nick Krause wrote:
> Hey Guys,
> I seem to be hitting my first kernel bug in the kernel stated in my
> subject line.
> When I transfer a lot of music for a brtfs external hard drive I have the music
> in clementine I am listening to is stopped for a few seconds and then continues.
> I just using basic intel audio, nothing amazing. When someone replies to this
> I will give more information as asked for :).
> Cheers Nick
> P.S. Thanks Guys for putting up with me a bit before I did something useful
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
