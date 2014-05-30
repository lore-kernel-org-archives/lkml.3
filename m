Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934010AbaE3Q2x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 12:28:53 -0400
Received: from mail-yk0-f181.google.com ([209.85.160.181]:42020 "EHLO
	mail-yk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932148AbaE3Q2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 12:28:52 -0400
MIME-Version: 1.0
In-Reply-To: <20140530135321.GQ3693@n2100.arm.linux.org.uk>
References: <1401457391-12242-1-git-send-email-mathieu.poirier@linaro.org>
	<1401457391-12242-5-git-send-email-mathieu.poirier@linaro.org>
	<20140530135321.GQ3693@n2100.arm.linux.org.uk>
Date: Fri, 30 May 2014 10:28:51 -0600
Message-ID: <CANLsYkyEBfyVhb3d1heFq1+QosSmHWDAd0V0Cq2QiKLdk9-a6g@mail.gmail.com>
Subject: Re: [RFC PATCH 04/11] coresight: add CoreSight ETB driver
From: Mathieu Poirier <mathieu.poirier@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Pratik Patel <pratikp@codeaurora.org>,
        Vikas Varshney <varshney@ti.com>, Al Grant <Al.Grant@arm.com>,
        Jonas Svennebring <jonas.svennebring@avagotech.com>,
        James King <james.king@linaro.org>,
        Panchaxari Prasannamurthy Tumkur 
	<panchaxari.prasannamurthy@linaro.org>,
        arnd@linaro.org, Marcin Jabrzyk <marcin.jabrzyk@gmail.com>,
        r.sengupta@samsung.com, Robert Marklund <robbelibobban@gmail.com>,
        Patch Tracking <patches@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Daniel Thompson <daniel.thompson@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 May 2014 07:53, Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> NAK for all the reasons I mentioned in the previous submission in 2012.
>
> You partially did the right thing - you read through the previous
> submission, and you said in your cover message that you had addressed
> some of the comments from that submission.
>
> What I find extremely distasteful is that you seem to have chosen to
> completely ignore my comments - you haven't mentioned them in your
> covering message at all, and you've just gone ahead and converted ETM
> and ETB to be platform devices.
>
> That gets you a NAK for that change, because you have done nothing what
> so ever to address the concerns I raised.

>From my initial reading of your assessment it wasn't clear to me that
your opinion leaned toward registering with the AMBA bus.  Now that
this point has been clarified I will go back to the AMBA interface for
my next submission.

Is there anything else not AMBA releated that you'd like to see modified?

Thanks,
Mathieu

>
> Since you seem to have ignored my comments, this is as far as I'm looking
> at your submission, and you can consider the entire submission NAK'd by
> me.
>
> Thanks.
>
> --
> FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
> improving, and getting towards what was expected from it.
