Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab3EIJDB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 05:03:01 -0400
Received: from multi.imgtec.com ([194.200.65.239]:10094 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045Ab3EIJC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 05:02:59 -0400
Message-ID: <518B663D.60806@imgtec.com>
Date: Thu, 9 May 2013 10:02:53 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Mike Turquette <mturquette@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/3] clk: implement remuxing during set_rate
References: <1366388904-13903-1-git-send-email-james.hogan@imgtec.com> <518AE16D.5060501@codeaurora.org>
In-Reply-To: <518AE16D.5060501@codeaurora.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_05_09_10_02_54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/13 00:36, Stephen Boyd wrote:
> On 04/19/13 09:28, James Hogan wrote:
>> This patchset adds support for automatic selection of the best parent
>> for a clock mux, i.e. the one which can provide the closest clock rate
>> to that requested. It can be controlled by a new CLK_SET_RATE_REMUX flag
>> so that it doesn't happen unless explicitly allowed.
>>
>> This works by way of adding a new op, determine_rate, similar to
>> round_rate but with an extra parameter to allow the clock driver to
>> optionally select a different parent clock. This is used in
>> clk_calc_new_rates to decide whether to initiate a set_parent operation.
> 
> Which tree is this based on? I get failures with git am on patch 2.
> 

It was based on v3.9-rc4.

Cheers
James

