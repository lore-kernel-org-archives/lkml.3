Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121AbaFJTNq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 15:13:46 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:63026 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018AbaFJTNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:13:44 -0400
Message-ID: <539758E6.7090301@kernel.dk>
Date: Tue, 10 Jun 2014 13:13:42 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Fabian Frederick <fabf@skynet.be>, linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] BLOCK/BLK-CGROUP: add __init to blkcg_policy_register
References: <1402424316-8933-1-git-send-email-fabf@skynet.be>
In-Reply-To: <1402424316-8933-1-git-send-email-fabf@skynet.be>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2014 12:18 PM, Fabian Frederick wrote:
> blkcg_policy_register is only called by
> __init functions:
> 
> __init cfq_init
> __init throtl_init

Thanks, applied.

-- 
Jens Axboe

