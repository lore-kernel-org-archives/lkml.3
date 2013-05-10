Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682Ab3EJKn5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 06:43:57 -0400
Received: from multi.imgtec.com ([194.200.65.239]:19619 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958Ab3EJKn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 06:43:56 -0400
Message-ID: <518CCF69.9040200@imgtec.com>
Date: Fri, 10 May 2013 11:43:53 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Mike Turquette <mturquette@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Saravana Kannan <skannan@codeaurora.org>
Subject: Re: [PATCH v2 0/3] clk: implement remuxing during set_rate
References: <1366388904-13903-1-git-send-email-james.hogan@imgtec.com> <518AE16D.5060501@codeaurora.org> <518B663D.60806@imgtec.com> <518BFD99.2010208@codeaurora.org>
In-Reply-To: <518BFD99.2010208@codeaurora.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_05_10_11_43_55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/13 20:48, Stephen Boyd wrote:
> On 05/09/13 02:02, James Hogan wrote:
>> On 09/05/13 00:36, Stephen Boyd wrote:
>>> Which tree is this based on? I get failures with git am on patch 2.
>>>
>> It was based on v3.9-rc4.
>>
> 
> Thanks. Would it be possible for you to update to Mike's for-next
> branch? I've done the rebase myself for now and it seems to work well
> enough. I'll need to add the set_rate_and_parent() op on top.
> 

Yes, I will do that before reposting. Thanks for giving it a spin.

Cheers
James

