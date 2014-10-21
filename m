Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933623AbaJUWMX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 18:12:23 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:55132 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933014AbaJUWMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 18:12:22 -0400
Message-ID: <5446DA45.6050603@infradead.org>
Date: Tue, 21 Oct 2014 15:12:21 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>, trivial@kernel.org, corbet@lwn.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] treewide: Fix typo in Documentation/DocBook/device-drivers
References: <1413903614-20775-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1413903614-20775-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/14 08:00, Masanari Iida wrote:
> This patch fix speeling typo found in html files within
> Documentation/DocBook/device-drivers.
> It is because html files are generated from comments in source,
> so I have to fix comments in the source.
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> ---
>  drivers/dma-buf/fence.c | 2 +-
>  include/linux/fence.h   | 4 ++--
>  include/linux/i2c.h     | 2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)


-- 
~Randy
