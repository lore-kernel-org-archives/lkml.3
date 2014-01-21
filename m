Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097AbaAUIqS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 03:46:18 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:64200 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbaAUIqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 03:46:17 -0500
Message-ID: <52DE33D0.1060703@linaro.org>
Date: Tue, 21 Jan 2014 16:46:08 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Michael wang <wangyun@linux.vnet.ibm.com>, mingo@redhat.com,
        peterz@infradead.org, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, daniel.lezcano@linaro.org, efault@gmx.de
CC: linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] sched/update_avg: avoid negative time
References: <1390282399-17091-1-git-send-email-alex.shi@linaro.org> <52DE1883.2070304@linux.vnet.ibm.com>
In-Reply-To: <52DE1883.2070304@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2014 02:49 PM, Michael wang wrote:
> This seems like won't happen...
> 
> if 'diff' is negative, it's absolute value won't bigger than '*avg', not
> to mention we only use 1/8 of it.

That's why I said 'sorry and forget this patch'. :(

-- 
Thanks
    Alex
