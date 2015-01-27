Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932390AbbA0QzR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 11:55:17 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:37535 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758682AbbA0QzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 11:55:15 -0500
Message-ID: <54C7C2EC.7010605@ahsoftware.de>
Date: Tue, 27 Jan 2015 17:55:08 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Richard Weinberger <richard@nod.at>, linux-mmc@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH] mmc: print message if a card supports secure erase/trim
References: <1422359304-30321-1-git-send-email-holler@ahsoftware.de> <CAFLxGvyuE8odPdNSD1PTccyBXFm=JO=ooikUOJfz41aFpsUAJg@mail.gmail.com> <54C77E69.7050600@ahsoftware.de> <20150127120855.GA9254@pd.tnic> <54C7816A.8050800@ahsoftware.de> <54C78524.3070901@nod.at> <54C7881F.6020501@ahsoftware.de> <20150127142120.GA3351@pd.tnic>
In-Reply-To: <20150127142120.GA3351@pd.tnic>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 27.01.2015 um 15:21 schrieb Borislav Petkov:
> On Tue, Jan 27, 2015 at 01:44:15PM +0100, Alexander Holler wrote:
>> Yes. Sorry, but I had so many bad experiences with maintainers.
>
> Well, I can't comment on your experience for the simple reason that I
> haven't followed those discussions. In their defence, though, you have
> to know that those people get to review your code, apply it and then
> deal with it long after you've gone on about doing other things.
>
> So, even if you don't always agree with them, you need to realize that
> those are the people responsible for that code and if they request a
> reasonable change in your submission, you have to do it. It is that
> simple.

Totally wrong. I'm free to just stop discussion. That's the difference 
between the old type of os communites and corporates where people do 
what they've got instructed from above without discussion. I offered 
something and wasn't paid to do something.

It was worth a try but I don't have to build a framework to achieve 
something simple just because a maintainer requests it.

>   [ Unless you have a good argument against it but that's a different
>     story and this is what is called the "review" process. ]

I want to see the mentionend information and want that it is seen and do 
not want to hide it away deep in the sysfs where it actually must be 
searched.

Regards,

Alexander Holler
