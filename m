Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751015AbaLOCxq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 21:53:46 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:41684 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbaLOCxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 21:53:42 -0500
Message-ID: <548E4D34.6000108@kernel.dk>
Date: Sun, 14 Dec 2014 19:53:40 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: nick <xerofoify@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers:block: Remove no longer needed FIXME comment
 for the function, add_disk in genhd.c
References: <1418526557-3295-1-git-send-email-xerofoify@gmail.com> <548E4A2D.2050603@kernel.dk> <548E4B85.1040602@gmail.com>
In-Reply-To: <548E4B85.1040602@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2014 07:46 PM, nick wrote:
> Jens,
> After rechecking the function definition we can't return an error as add_disk is declared void. Should I change the function to an int and then return an error. My thinking was that there is no good way to return an error code without
> a breakage in the functions that  call add_disk.

Please don't top post...

It's a big job, it requires properly checking and updating all block 
drivers. But yes, that is what would be required in removing that TODO.

-- 
Jens Axboe

