Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502Ab3EPJ1L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 05:27:11 -0400
Received: from multi.imgtec.com ([194.200.65.239]:26329 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038Ab3EPJ1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 05:27:08 -0400
Message-ID: <5194A618.3040900@imgtec.com>
Date: Thu, 16 May 2013 10:25:44 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Saravana Kannan <skannan@codeaurora.org>
CC: Mike Turquette <mturquette@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/3] clk: implement remuxing during set_rate
References: <1366388904-13903-1-git-send-email-james.hogan@imgtec.com> <51945C7F.2030605@codeaurora.org>
In-Reply-To: <51945C7F.2030605@codeaurora.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_05_16_10_27_07
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/05/13 05:11, Saravana Kannan wrote:
> I really want to review this because I solved the same problem in our
> internal clock framework and want to make sure upstream doesn't go
> through the same mistakes. But haven't had the time. Hopefully, I'll go
> it before this gets accepted by Mike. I'll try to do it this week/weekend.

Great! FYI I submitted a v3 yesterday, but screwed up and forgot to CC
LKML :-(

It can be found on linux-arm-kernel archives here (or if it's a real
PITA I can resubmit cc'ing LKML):

http://lists.infradead.org/pipermail/linux-arm-kernel/2013-May/168485.html

Cheers
James

