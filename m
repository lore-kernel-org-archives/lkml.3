Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539AbaFXWPZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 18:15:25 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:49622 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbaFXWPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 18:15:24 -0400
Message-ID: <53A9F884.4090609@kernel.dk>
Date: Tue, 24 Jun 2014 16:15:32 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Gu Zheng <guz.fnst@cn.fujitsu.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC: Kent <kmo@daterainc.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] bio: remove unused macro bip_vec_idx()
References: <53A94E92.9090105@cn.fujitsu.com>
In-Reply-To: <53A94E92.9090105@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2014 04:10 AM, Gu Zheng wrote:
> Macro bip_vec_idx() was used by bio integrity originally, but no longer
> used now. So remove it.

Thanks, applied.

-- 
Jens Axboe

