Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580AbaB0XZx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 18:25:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40475 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbaB0XZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 18:25:52 -0500
Date: Thu, 27 Feb 2014 15:25:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>, Jerome Marchand <jmarchan@redhat.com>,
        Nitin Gupta <ngupta@vflare.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv8 4/6] zram: add multi stream functionality
Message-Id: <20140227152550.f29e76024a26c8f5972649d9@linux-foundation.org>
In-Reply-To: <1393417679-13657-5-git-send-email-sergey.senozhatsky@gmail.com>
References: <1393417679-13657-1-git-send-email-sergey.senozhatsky@gmail.com>
	<1393417679-13657-5-git-send-email-sergey.senozhatsky@gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Feb 2014 15:27:57 +0300 Sergey Senozhatsky <sergey.senozhatsky@gmail.com> wrote:

> This patch implements multi stream compression support.
> 
> ...
>
> @@ -693,6 +729,8 @@ static DEVICE_ATTR(initstate, S_IRUGO, initstate_show, NULL);
>  static DEVICE_ATTR(reset, S_IWUSR, NULL, reset_store);
>  static DEVICE_ATTR(orig_data_size, S_IRUGO, orig_data_size_show, NULL);
>  static DEVICE_ATTR(mem_used_total, S_IRUGO, mem_used_total_show, NULL);
> +static DEVICE_ATTR(max_comp_streams, S_IRUGO | S_IWUSR,
> +		max_comp_streams_show, max_comp_streams_store);
>  

Update Documentation/blockdev/zram.txt and
Documentation/ABI/testing/sysfs-block-zram, please.

