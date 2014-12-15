Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751165AbaLOCk4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 21:40:56 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:35478 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbaLOCkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 21:40:47 -0500
Message-ID: <548E4A2D.2050603@kernel.dk>
Date: Sun, 14 Dec 2014 19:40:45 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Nicholas Krause <xerofoify@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers:block: Remove no longer needed FIXME comment
 for the function, add_disk in genhd.c
References: <1418526557-3295-1-git-send-email-xerofoify@gmail.com>
In-Reply-To: <1418526557-3295-1-git-send-email-xerofoify@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2014 08:09 PM, Nicholas Krause wrote:
> Removes unneeded fix me comment related to the function, add_disk needing error handling. The function clearly has supported this for a while and the comment is not longer needed
> for the function,add_disk in the file genhd.c.

But it doesn't, really. Proper error handling would be to unroll and 
return the error, if it happens. Right now add_disk() can't return an error.

-- 
Jens Axboe

