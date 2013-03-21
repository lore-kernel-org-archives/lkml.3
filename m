Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932603Ab3CUMfQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 08:35:16 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55330 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758110Ab3CUMfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 08:35:11 -0400
Message-ID: <514AFDD5.9020608@ti.com>
Date: Thu, 21 Mar 2013 18:02:21 +0530
From: Mugunthan V N <mugunthanvnm@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: =?UTF-8?B?TG90aGFyIFdhw59tYW5u?= <LW@KARO-electronics.de>
CC: Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [BUGFIX PATCH] net: ethernet: cpsw: fix erroneous condition in
 error check
References: <1363868411-25318-1-git-send-email-LW@KARO-electronics.de>
In-Reply-To: <1363868411-25318-1-git-send-email-LW@KARO-electronics.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/21/2013 5:50 PM, Lothar Waßmann wrote:
> The error check in cpsw_probe_dt() has an '&&' where an '||' is
> meant to be. This causes a NULL pointer dereference when incomplet DT
> data is passed to the driver ('phy_id' property for cpsw_emac1
> missing).
>
>
> Signed-off-by: Lothar Waßmann<LW@KARO-electronics.de>
Acked-by: Mugunthan V N <mugunthanvnm@ti.com>

Regards
Mugunthan V N
