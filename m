Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374AbaBTHVh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 02:21:37 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:47935 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbaBTHVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 02:21:36 -0500
Message-ID: <5305ACF9.60403@linaro.org>
Date: Thu, 20 Feb 2014 15:21:29 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [sched/balance] 7511dd0a7: +2.1e+05% context switches
References: <20140219130028.GB8169@localhost>
In-Reply-To: <20140219130028.GB8169@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2014 09:00 PM, Fengguang Wu wrote:
> bc575710efe937e  7511dd0a73aaf2ca4bcd829f9
> ---------------  -------------------------
>       2029 ~ 0%    +222.9%       6551 ~17%  lkp-snb01/micro/will-it-scale/pthread_mutex2
>     143678 ~42%  +4.8e+05%  6.927e+08 ~ 0%  lkp-snb01/micro/will-it-scale/sched_yield
>     145708 ~42%  +4.8e+05%  6.927e+08 ~ 0%  TOTAL time.involuntary_context_switches


Thanks for testing, Fengguang!

Does the context switch increasing happen on whole patchset? or just
happens on this patch?

-- 
Thanks
    Alex
