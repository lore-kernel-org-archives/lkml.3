Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab3KGPcw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 10:32:52 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57047 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327Ab3KGPcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 10:32:48 -0500
Message-ID: <527BB1EE.9070405@kernel.dk>
Date: Thu, 07 Nov 2013 08:29:50 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Duan Jiong <duanj.fnst@cn.fujitsu.com>, kernel@pengutronix.de,
        linux@arm.linux.org.uk, a.zummo@towertech.it, airlied@linux.ie,
        dmitry.torokhov@gmail.com
CC: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-input@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH] block: replace IS_ERR and PTR_ERR with PTR_ERR_OR_ZERO
References: <1383724599-15754-1-git-send-email-duanj.fnst@cn.fujitsu.com>
In-Reply-To: <1383724599-15754-1-git-send-email-duanj.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2013 12:56 AM, Duan Jiong wrote:
> This patch fixes coccinelle error regarding usage of IS_ERR and
> PTR_ERR instead of PTR_ERR_OR_ZERO.

Applied, thanks.

-- 
Jens Axboe

