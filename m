Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751482Ab3HSLjY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 07:39:24 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44250 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263Ab3HSLjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 07:39:22 -0400
Message-ID: <521203E7.8000502@ti.com>
Date: Mon, 19 Aug 2013 17:09:19 +0530
From: Mugunthan V N <mugunthanvnm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: <ujhelyi.m@gmail.com>
CC: <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2] net: cpsw: Add support for wake-on-lan for cpsw
References: <1376910358-19882-1-git-send-email-ujhelyi.m@gmail.com>
In-Reply-To: <1376910358-19882-1-git-send-email-ujhelyi.m@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 August 2013 04:35 PM, ujhelyi.m@gmail.com wrote:
> From: Matus Ujhelyi <ujhelyi.m@gmail.com>
>
> Some phy's can be configured to enable wake on lan (e.g. at803x or marvell 88E1318S).
> There is no way how to enable wol on CPSW with such connected phys. This patch
> adds this support. It is provided by calling the phy's related code.
>
> Tested on board with at8030x connected phy. Wol interrupt line is
> connected to GPIO0 on am335x.
>
> Signed-off-by: Matus Ujhelyi <ujhelyi.m@gmail.com>
Looks good to me.
Acked-by: Mugunthan V N <mugunthanvnm@gmail.com>

Regards
Mugunthan V N
