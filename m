Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751496AbaBGEcn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 23:32:43 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:53764 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbaBGEcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 23:32:41 -0500
Message-ID: <52F461E6.7070608@gmail.com>
Date: Thu, 06 Feb 2014 20:32:38 -0800
From: Frank Rowand <frowand.list@gmail.com>
Reply-To: frowand.list@gmail.com
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: frowand.list@gmail.com, Stephen Boyd <sboyd@codeaurora.org>
CC: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, Saravana Kannan <skannan@codeaurora.org>
Subject: Re: [PATCH v5 00/14] Add support for MSM's mmio clock/reset controller
References: <1389811654-21397-1-git-send-email-sboyd@codeaurora.org> <52F45DEE.8020400@gmail.com>
In-Reply-To: <52F45DEE.8020400@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/6/2014 8:15 PM, Frank Rowand wrote:
> On 1/15/2014 10:47 AM, Stephen Boyd wrote:
>> The first breaks a reset-controller include ordering requirement. It got
>> an ack so I think we're ok for it to go through the clock tree.
>>
> 
> < snip >
> 
> checkpatch is whining about patches
> 

< snip >

Never mind....  I see that the patches are already in 3.14-rc1.

-Frank

