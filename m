Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521AbaAPCI5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 21:08:57 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:33109 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381AbaAPCIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 21:08:54 -0500
Message-ID: <52D73F31.2010008@linaro.org>
Date: Thu, 16 Jan 2014 10:08:49 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [sched] b75e43bb77d: +87% hackbench.throughput
References: <20140116013508.GB13621@localhost>
In-Reply-To: <20140116013508.GB13621@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2014 09:35 AM, Fengguang Wu wrote:
> Alex,
> 
> We noticed that commit b75e43bb77d ("sched: find the latest idle cpu")
> increased hackbench throughput by +87% in test case hackbench
> 1600%-threads-pipe on a 2S SNB server.

Awesome! Thanks for testing!

-- 
Thanks
    Alex
