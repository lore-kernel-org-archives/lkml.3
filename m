Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208AbaCMHnU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 03:43:20 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:48753 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbaCMHnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 03:43:19 -0400
Message-ID: <5321618F.3090801@linaro.org>
Date: Thu, 13 Mar 2014 15:43:11 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [sched/balance] INFO: possible recursive locking detected
References: <20140303142526.GA8517@localhost>
In-Reply-To: <20140303142526.GA8517@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2014 10:25 PM, Fengguang Wu wrote:
> Greetings,
> 
> I got the below dmesg and the first bad commit is
> 
> https://github.com/alexshi/power-scheduling.git single-balance.bak
> commit 2adc591a5cb6768ad11e63be9011906aa171148d
> Author:     Alex Shi <alex.shi@linaro.org>
> AuthorDate: Fri Feb 28 15:25:09 2014 +0800
> Commit:     Alex Shi <alex.shi@linaro.org>
> CommitDate: Sun Mar 2 09:16:38 2014 +0800
> 
>     sched/balance: replace new_idle_balance
>     
>     Curren idle_balance will pull task on half of this group. That is
>     not needed in central balance.


Thanks for your testing, Fengguang!

I fixed this issue and updated to the git tree. Is the single-balance
branch still in your performance radar? :)

-- 
Thanks
    Alex
