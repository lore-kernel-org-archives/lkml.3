Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403AbaKDP1w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 10:27:52 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:32780 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312AbaKDP1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 10:27:51 -0500
Message-ID: <5458F074.4020704@kernel.dk>
Date: Tue, 04 Nov 2014 08:27:48 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: Expand a bit documentation about elevator_allow_merge_fn
References: <1415101961-18443-1-git-send-email-jack@suse.cz>
In-Reply-To: <1415101961-18443-1-git-send-email-jack@suse.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-11-04 04:52, Jan Kara wrote:
> Explain that two requests can be merged without
> elevator_allow_merge_fn() being called.

Thanks Jan, applied.

-- 
Jens Axboe

