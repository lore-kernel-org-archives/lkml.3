Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957AbaETSyq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 14:54:46 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:61272 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbaETSyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 14:54:45 -0400
Message-ID: <537BA4F7.5060500@kernel.dk>
Date: Tue, 20 May 2014 12:54:47 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Asai Thambi S P <asamymuthupa@micron.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Selvan Mani <smani@micron.com>, Sam Bradshaw <sbradshaw@micron.com>
Subject: Re: [PATCH] mtip32xx: move error handling to service thread
References: <537B9588.2000306@micron.com>
In-Reply-To: <537B9588.2000306@micron.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2014 11:48 AM, Asai Thambi S P wrote:
> 
> Move error handling to service thread, and use mtip_set_timeout()
> to set timeouts for HDIO_DRIVE_TASK and HDIO_DRIVE_CMD IOCTL commands.

Thanks Asai, applied.

-- 
Jens Axboe

