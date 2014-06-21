Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758220AbaFUNVe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 09:21:34 -0400
Received: from zabrina.hetzner-de.towertech.it ([178.63.16.19]:37861 "EHLO
	zabrina.hetzner-de.towertech.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752652AbaFUNVd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 09:21:33 -0400
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (1.0)
Subject: Re: rtc/hctosys.c Problem during kernel boot
From: Alessandro Zummo <a.zummo@towertech.it>
X-Mailer: iPhone Mail (11D201)
In-Reply-To: <53A583DC.504@ahsoftware.de>
Date: Sat, 21 Jun 2014 15:21:18 +0200
Cc: John Stultz <john.stultz@linaro.org>, John Whitmore <arigead@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <D25FD09C-587C-4412-A508-7AFA3FFB89C2@towertech.it>
References: <20140611230127.GA28066@griso.site> <CANcMJZDqAmdFLYq2LW60zU_d05Pv8tcYE1Nb=ftZcj5UukxqaA@mail.gmail.com> <53A583DC.504@ahsoftware.de>
To: Alexander Holler <holler@ahsoftware.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm testing them and they're working fine so far. Will handle them the next week. 

--
 Best regards,
  Alessandro Zummo
     Tower Technologies

Sent from my iPhone, please excuse my brevity. 

> On 21/giu/2014, at 15:08, Alexander Holler <holler@ahsoftware.de> wrote:
> 
> Am 12.06.2014 01:53, schrieb John Stultz:
> 
>> You can read some of the previous discussion here:
>> https://lkml.org/lkml/2013/6/17/533
>> 
>> I'd be very interested in patches to resolve this!
> 
> And the silence as response to my repost of my already working patches just proved that isn't true.
> 
> So (John Whitmore), I suggest to not post patches, Linux kernel maintainers don't really have an interest in getting things done or to fix bugs, they just need fresh meat they can review in order to have job security and prove their status.
> 
> I really wonder what's their expectation. Do they really think other people have to incorporate their (often silly) requests, making the maintainers themself not responsible for their requested changes? Do they think other people have fun and time to write and post patches again and again just to make some arbitrary maintainer happy?
> 
> If there really would be an interest, a reasonable approach would be to just take my patches and put a patch on top with whatever changes someone thinks are needed. As I don't think there are changes needed, I will not add such changes using my name as author.
> 
> And don't try to tell me I'm uncooperative. I've spend time to write these patches and even have written documentation I don't need myself. The uncooperative people which are blocking almost everthing and which do ignore bugs have become these people which are calling themself Linux kernel maintainers which do expect other people have to play remote keyboard and have to take responsibility for changes maintainers don't want to be responsible for themself.
> 
> So the above quoted sentence is just another "marketing" verbiage, at least in my point of view.
> 
> Alexander Holler
> 
