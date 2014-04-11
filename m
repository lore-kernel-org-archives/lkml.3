Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936AbaDKOJ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 10:09:58 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:47966 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149AbaDKOJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 10:09:56 -0400
Message-ID: <5347F7B7.9000200@kernel.dk>
Date: Fri, 11 Apr 2014 08:09:59 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Duan Jiong <duanj.fnst@cn.fujitsu.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: replace IS_ERR and PTR_ERR with PTR_ERR_OR_ZERO
References: <1397203136-16712-1-git-send-email-duanj.fnst@cn.fujitsu.com>
In-Reply-To: <1397203136-16712-1-git-send-email-duanj.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2014 01:58 AM, Duan Jiong wrote:
> This patch fixes coccinelle error regarding usage of IS_ERR and
> PTR_ERR instead of PTR_ERR_OR_ZERO.

Thanks, applied for 3.16.

-- 
Jens Axboe

