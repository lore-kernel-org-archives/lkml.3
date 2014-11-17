Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112AbaKQK0E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 05:26:04 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:38943 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019AbaKQK0C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 05:26:02 -0500
Message-ID: <5469CD3F.1010503@mm-sol.com>
Date: Mon, 17 Nov 2014 12:26:07 +0200
From: Georgi Djakov <gdjakov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: mturquette@linaro.org
CC: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] clk: qcom: Fix duplicate rbcpr clock name
References: <1412949444-9792-1-git-send-email-gdjakov@mm-sol.com> <20141011001632.GI5493@codeaurora.org>
In-Reply-To: <20141011001632.GI5493@codeaurora.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2014 03:16 AM, Stephen Boyd wrote:
> On 10/10, Georgi Djakov wrote:
>> There is a duplication in a clock name for apq8084 platform that causes
>> the following warning: "RBCPR_CLK_SRC" redefined
>>
>> Resolve this by adding a MMSS_ prefix to this clock and making its name
>> coherent with msm8974 platform.
>>
>> Fixes: 2b46cd23a5a2 ("clk: qcom: Add APQ8084 Multimedia Clock Controller (MMCC) support")
>> Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
> 
> Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
> 
<..>

Hi Mike,
Would you please queue this fix?

Thanks,
Georgi
