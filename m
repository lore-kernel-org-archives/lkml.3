Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933153AbaJWCO7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 22:14:59 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:48830 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932353AbaJWCO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 22:14:56 -0400
Message-ID: <5448649D.7090403@kernel.dk>
Date: Wed, 22 Oct 2014 20:14:53 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jan Kara <jack@suse.cz>
Subject: Re: linux-next: build warning after merge of the block tree
References: <20141023122822.2c362904@canb.auug.org.au>
In-Reply-To: <20141023122822.2c362904@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-10-22 19:28, Stephen Rothwell wrote:
> Hi Jens,
>
> After merging the block tree, today's linux-next build (x86_64
> allmodconfig) produced this warning:
>
> block/scsi_ioctl.c: In function 'sg_scsi_ioctl':
> block/scsi_ioctl.c:520:1: warning: label 'out' defined but not used [-Wunused-label]
>   out:
>   ^

Fixed up, thanks.


-- 
Jens Axboe

