Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629AbaE0OiA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 10:38:00 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:48828 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037AbaE0Oh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 10:37:59 -0400
MIME-Version: 1.0
In-Reply-To: <5384A2DB.404@kernel.dk>
References: <1401200414-10823-1-git-send-email-tom.leiming@gmail.com>
	<5384A2DB.404@kernel.dk>
Date: Tue, 27 May 2014 22:37:58 +0800
Message-ID: <CACVXFVPudj=dxK9wom4y5O1ztAZ1V6aKp6-eXtC4b48f2FrAdw@mail.gmail.com>
Subject: Re: [PATCH 0/3] blk-mq: fix leak of hctx->ctx_map
From: Ming Lei <tom.leiming@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 10:36 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 05/27/2014 08:20 AM, Ming Lei wrote:
>> Misc changes.
>
> All look good, however they don't apply to the current for-3.16/core
> branch. What are they against? I hand applied 1, but could you
> regenerate 2+3 against the current tree?

It is against your tree several days ago, and will resend the 2nd
and 3rd out.


Thanks,
-- 
Ming Lei
