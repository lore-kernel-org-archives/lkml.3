Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407AbaDVOQN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 10:16:13 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:46571 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755854AbaDVOQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 10:16:08 -0400
Message-ID: <535679A4.4050507@kernel.dk>
Date: Tue, 22 Apr 2014 08:16:04 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Jianyu Zhan <nasa4836@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] blk-cgroup: explicitly init the early_init field
References: <1398144370-9236-1-git-send-email-nasa4836@gmail.com>
In-Reply-To: <1398144370-9236-1-git-send-email-nasa4836@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-04-21 23:26, Jianyu Zhan wrote:
> For a cgroup subsystem who should init early, then it should carefully
> take care of the implementation of css_alloc, because it will be called
> before mm_init() setup the world.
>
> Luckily we don't, and we better explicitly assign the early_init field
> to 0, for document reason.

The rest of the members will be zero-filled by default, so your patch 
should not change anything.

-- 
Jens Axboe

