Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561AbaE0OgI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 10:36:08 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:58670 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbaE0OgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 10:36:02 -0400
Message-ID: <5384A2DB.404@kernel.dk>
Date: Tue, 27 May 2014 08:36:11 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Ming Lei <tom.leiming@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] blk-mq: fix leak of hctx->ctx_map
References: <1401200414-10823-1-git-send-email-tom.leiming@gmail.com>
In-Reply-To: <1401200414-10823-1-git-send-email-tom.leiming@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2014 08:20 AM, Ming Lei wrote:
> Misc changes.

All look good, however they don't apply to the current for-3.16/core
branch. What are they against? I hand applied 1, but could you
regenerate 2+3 against the current tree?

-- 
Jens Axboe

