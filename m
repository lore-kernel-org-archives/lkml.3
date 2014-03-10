Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811AbaCJIpY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 04:45:24 -0400
Received: from top.free-electrons.com ([176.31.233.9]:47557 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752191AbaCJIpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 04:45:22 -0400
Message-ID: <531D7BA0.9040802@free-electrons.com>
Date: Mon, 10 Mar 2014 09:45:20 +0100
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Lennox Wu <lennox.wu@gmail.com>, open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [RESEND] score: remove unused CPU_SCORE7 Kconfig parameter
References: <1386567192-19924-1-git-send-email-michael.opdenacker@free-electrons.com>	<1394256390-10603-1-git-send-email-michael.opdenacker@free-electrons.com> <CAF0htA5OyL=cm7z5BMy1r7OcW_a-4WGEUbLzveR4fWgAC5av0Q@mail.gmail.com>
In-Reply-To: <CAF0htA5OyL=cm7z5BMy1r7OcW_a-4WGEUbLzveR4fWgAC5av0Q@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2014 07:34 AM, Lennox Wu wrote:
> HI Michael,
> According to my record, I had told you we have another
> processor(2013/11/4), hence, we need the parameter.
> We just wirte it done first. Do you remember it?
Hi Lennox,

I missed your reply because it got deleted by mistake. My apologies!

However, I agree with Paul in the sense that keeping such a parameter
for a long time before it is actually used just adds some unnecessary
noise, hiding the parameters that would really need removing.

And indeed, it will be hard to stop other people from reporting this
again in the future...

Thank you for your replies.

Cheers,

Michael.

-- 
Michael Opdenacker, CEO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
+33 484 258 098

