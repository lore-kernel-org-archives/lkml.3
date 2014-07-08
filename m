Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496AbaGHJTB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 05:19:01 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:34583 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691AbaGHJS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 05:18:59 -0400
Message-ID: <53BBB77D.40005@ti.com>
Date: Tue, 8 Jul 2014 14:48:53 +0530
From: Mugunthan V N <mugunthanvnm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: <netdev@vger.kernel.org>
CC: <davem@davemloft.net>, <linux-api@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [net-next PATCH 3/3] drivers: net: cpsw: Add support for multicast/boradcast
 rate limit
References: <1404809861-7040-1-git-send-email-mugunthanvnm@ti.com> <1404809861-7040-4-git-send-email-mugunthanvnm@ti.com>
In-Reply-To: <1404809861-7040-4-git-send-email-mugunthanvnm@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 July 2014 02:27 PM, Mugunthan V N wrote:
> Add support for multicast/boradcast rate limit feature via ethtool coalesce.
>
> Signed-off-by: Mugunthan V N <mugunthanvnm@ti.com>

s/boradcast/broadcast

Will fix this in next patch set.

Regards
Mugunthan V N
