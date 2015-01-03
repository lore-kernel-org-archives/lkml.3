Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871AbbACOvg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 09:51:36 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:38753 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbbACOvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 09:51:32 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CAKXHbyPm+2gy3E_FAVY82ggvJhWe-E_xtrhgeAPxUyRS-FutaA@mail.gmail.com>
References: <1420127170-28421-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<CACna6rznUcqGTK0t1k=kjn0NVLycq865780ozyB+VYu78d_BSg@mail.gmail.com>
	<CACna6rxbGRdw7XSYvHAJGxJvMVwjVbAL4ynBM3m9rNggh7gCVQ@mail.gmail.com>
	<CA+icZUWOXMEyobZkudW9BEfkaWFTXQL9XF26g7oJMCzt=4==6g@mail.gmail.com>
	<CAKXHbyO70WdWekSYCY9spMbX2+_kdKTp3JoreDKpCdUBzFwYqw@mail.gmail.com>
	<CACna6rxTYUWvxvu0rFydWxkjbYdHfhV=o+9A+ViCpbV-LFx7fw@mail.gmail.com>
	<CAKXHbyMqTk=k7eieBNtAD+n6+4w3weL82twHBo-o8ebm_3+wvg@mail.gmail.com>
	<CA+icZUUJfemKC85=p7Huyw7xwfUdXBhePseJCnUKLx9edgpT4w@mail.gmail.com>
	<CAKXHbyPm+2gy3E_FAVY82ggvJhWe-E_xtrhgeAPxUyRS-FutaA@mail.gmail.com>
Date: Sat, 3 Jan 2015 15:51:30 +0100
Message-ID: <CA+icZUUfFr2PQjp4ppMNj5UQE3U7-ArmO1LSDoZZf5c1Y85OMw@mail.gmail.com>
Subject: Re: [PATCH] net: wireless: b43legacy: radio.c: Remove unused function
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Stefano Brivio <stefano.brivio@polimi.it>,
        Network Development <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 3, 2015 at 3:45 PM, Rickard Strandqvist
<rickard_strandqvist@spectrumdigital.se> wrote:
[ ... ]
>> > I just got one more complaining about my subject-line in "net: wireless: "
>> > I use some sed call for this, so it's easy to fix. I will now remove that
>> > part hereinafter.
>> > I check in Documentation/ but did not find any clear info for this.
>> >
>>
>> The easiest way to make (sub)maintainers happy is to check the git-log...
>>
>> $ git log --oneline /path/to/file
>>
>> ...and look how other contributors labeled their patches.
>>
>> [1] is the 1st address to look at on how to submit patches to Linux-kernel.
>> To promote the good work of Greg, see [2,3] for a video and tutorial
>> on that topic, too.
>>
>> - Sedat -
>>
>> [1] http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/SubmittingPatches
>> [2] https://www.youtube.com/watch?v=XXix80GCvpo
>> [3] https://github.com/gregkh/kernel-tutorial
>
>
>
> Hi Sedat
>
> Thanks for the tip :)
>
> To bad with the audio in the video thow. Have read SubmittingPatches before.
>

AFAICS there is another (earlier) video "Write and Submit your first
Linux kernel Patch" from FOSDEM 2010.

For German readers I can recommend the book from [2] (no I get no
money for promotion).

- Sedat -

[1] https://www.youtube.com/watch?v=LLBrBBImJt4
[2] http://www.opensourcepress.de/de/produkte/Git/33227/978-3-95539-119-5-

>
> But I have now added a line in my script that does a:
>
> git log -10 --oneline
>
> So I can at least see the other subjekt lines, and make adjustments if
> necessary.
>
>
>
> Kind regards
> Rickard Strandqvist
