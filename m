Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973AbaFJTNh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 15:13:37 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:48732 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbaFJTNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:13:35 -0400
Message-ID: <539758DD.3060002@kernel.dk>
Date: Tue, 10 Jun 2014 13:13:33 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Fabian Frederick <fabf@skynet.be>, linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] BLOCK/ELEVATOR: add __init to elv_register
References: <1402423490-7271-1-git-send-email-fabf@skynet.be>
In-Reply-To: <1402423490-7271-1-git-send-email-fabf@skynet.be>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2014 12:04 PM, Fabian Frederick wrote:
> elv_register is only called by elevator init functions:
> 
> __init cfq_init
> __init deadline_init
> __init noop_init

Thanks, applied.

-- 
Jens Axboe

