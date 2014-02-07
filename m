Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751420AbaBGEPy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 23:15:54 -0500
Received: from mail-qa0-f52.google.com ([209.85.216.52]:49932 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaBGEPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 23:15:52 -0500
Message-ID: <52F45DEE.8020400@gmail.com>
Date: Thu, 06 Feb 2014 20:15:42 -0800
From: Frank Rowand <frowand.list@gmail.com>
Reply-To: frowand.list@gmail.com
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, Saravana Kannan <skannan@codeaurora.org>
Subject: Re: [PATCH v5 00/14] Add support for MSM's mmio clock/reset controller
References: <1389811654-21397-1-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1389811654-21397-1-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/15/2014 10:47 AM, Stephen Boyd wrote:
> The first breaks a reset-controller include ordering requirement. It got
> an ack so I think we're ok for it to go through the clock tree.
> 

< snip >

checkpatch is whining about patches

  4
  5
  6
  7
  8

(Just for completeness if someone thinks I did not check all the patches,
it also whines about patch 11, but I think the whining should be ignored,
and it whines about patch 1 but I think that might be a checkpatch bug.)

-Frank

