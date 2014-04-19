Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751167AbaDSFFK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 01:05:10 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:53205 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbaDSFFI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 01:05:08 -0400
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH next 3/4] blk-mq: user (1 << order) to implement order_to_size()
From: Jens Axboe <axboe@kernel.dk>
X-Mailer: iPhone Mail (11D167)
In-Reply-To: <CACVXFVMZ0LmpkYk5+-4yyosapzUp+te4txFq3iO09PpGKEXWRA@mail.gmail.com>
Date: Fri, 18 Apr 2014 22:05:04 -0700
Cc: =?utf-8?Q?J=C3=B6rg-Volker_Peetz?= <jvpeetz@web.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>
Content-Transfer-Encoding: 8BIT
Message-Id: <B2C4D47E-30F0-4CC3-B3AD-22C791F61614@kernel.dk>
References: <1397749778-14485-1-git-send-email-tom.leiming@gmail.com> <1397749778-14485-4-git-send-email-tom.leiming@gmail.com> <5350257A.30107@web.de> <CACVXFVMFuiHpM-bVjyutP7fH621Gt0bo2+HLwRbk_aGsiZ+1Vw@mail.gmail.com> <53517BC5.7090002@web.de> <CACVXFVMZ0LmpkYk5+-4yyosapzUp+te4txFq3iO09PpGKEXWRA@mail.gmail.com>
To: Ming Lei <tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 18, 2014, at 8:17 PM, Ming Lei <tom.leiming@gmail.com> wrote:
> 
>> On Sat, Apr 19, 2014 at 3:23 AM, Jörg-Volker Peetz <jvpeetz@web.de> wrote:
>> 
>> Testing this with gcc 4.8.2 with order > 30 confirms that the automatic casting
>> is done operator-wise and the explicit casting is necessary.
> 
> My gcc 4.8.2 doesn't complain the change, see below:

It won't complain, but that doesn't mean that it won't get it wrong. The cast is necessary.

