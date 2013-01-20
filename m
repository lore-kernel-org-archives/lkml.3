Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751672Ab3ATFv7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 00:51:59 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4076 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890Ab3ATFv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 00:51:57 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Sat, 19 Jan 2013 21:50:35 -0800
Message-ID: <50FB85F9.4090007@nvidia.com>
Date: Sun, 20 Jan 2013 13:51:53 +0800
From: Mark Zhang <markz@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>
Subject: Re: [PATCH 0/3] pwm-backlight: add subdrivers & Tegra support
References: <1358591420-7790-1-git-send-email-acourbot@nvidia.com> <50FB669C.3020704@nvidia.com> <CAAVeFuKkw3b-Jw1s7tc8YUyH6sg8ipqBFFxs4tUBrj9_BDsBMA@mail.gmail.com>
In-Reply-To: <CAAVeFuKkw3b-Jw1s7tc8YUyH6sg8ipqBFFxs4tUBrj9_BDsBMA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2013 01:26 PM, Alexandre Courbot wrote:
> On Sun, Jan 20, 2013 at 12:38 PM, Mark Zhang <markz@nvidia.com> wrote:
>> So this is a non power sequence version of backlight & panel enabling,
>> isn't it? I remember we talked about this several days ago and you
>> mentioned kernel guys want an ad-hoc version(power sequence logics
>> inside driver, not in DT) and I believe this is it, right?
> 
> Basically, yes - I still think power-seqs could be useful here
> (especially after seeing the size of these sub-drivers if you want to
> do error checking properly) and plan to give it another shot without
> DT, but this will not happen soon since we need to do some GPIO
> redesign before. You can see what's wrong in the init() function of
> the subdriver: we call a device tree function to obtain the GPIO as
> there is no get function.
>

Okay. I think I got the picture. I'll read the codes when I'm free and I
think I'll understand this better after that.

>> I think finally I can enable Tegra30 cardhu's display after this patch
>> merged.
> 
> Yes, feel free to write a subdriver for Cardhu if you like - I'd like
> to see all T20 and T30 boards supported by the time this gets merged.
> 

Yep, I can try to do that. I'll let you know if I have problems.

Mark
> Thanks,
> Alex.
> 
