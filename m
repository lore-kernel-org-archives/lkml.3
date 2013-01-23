Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616Ab3AWRNo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 12:13:44 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:60733 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754655Ab3AWRNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 12:13:43 -0500
Message-ID: <51001A5F.1080903@gmail.com>
Date: Wed, 23 Jan 2013 18:14:07 +0100
From: Francesco Lavra <francescolavra.fl@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
CC: Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org
Subject: Re: [Linaro-mm-sig] [PATCH 4/7] fence: dma-buf cross-device synchronization
 (v11)
References: <1358253244-11453-1-git-send-email-maarten.lankhorst@canonical.com> <1358253244-11453-5-git-send-email-maarten.lankhorst@canonical.com> <50FEAC87.7090702@gmail.com> <50FFFA31.6000101@canonical.com>
In-Reply-To: <50FFFA31.6000101@canonical.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2013 03:56 PM, Maarten Lankhorst wrote:
> Thanks for the review, how does this delta look?
> 
> diff --git a/include/linux/fence.h b/include/linux/fence.h
> index d9f091d..831ed0a 100644
> --- a/include/linux/fence.h
> +++ b/include/linux/fence.h
> @@ -42,7 +42,10 @@ struct fence_cb;
>   * @ops: fence_ops associated with this fence
>   * @cb_list: list of all callbacks to call
>   * @lock: spin_lock_irqsave used for locking
> - * @priv: fence specific private data
> + * @context: execution context this fence belongs to, returned by
> + *           fence_context_alloc()
> + * @seqno: the sequence number of this fence inside the executation context,

s/executation/execution

Otherwise, looks good to me.

--
Francesco
