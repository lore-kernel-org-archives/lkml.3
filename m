Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200AbaCYAAu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 20:00:50 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43387 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751589AbaCYAAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 20:00:46 -0400
Message-ID: <5330C703.5030705@ti.com>
Date: Mon, 24 Mar 2014 20:00:03 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, Jason Cooper <jason@lakedaemon.net>
Subject: Re: linux-next: manual merge of the keystone tree with the arm-soc
 tree
References: <20140325105501.e63fcdd78d0d604b4e5309a1@canb.auug.org.au>
In-Reply-To: <20140325105501.e63fcdd78d0d604b4e5309a1@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 24 March 2014 07:55 PM, Stephen Rothwell wrote:
> Hi Santosh,
> 
> Today's linux-next merge of the keystone tree got a conflict in
> arch/arm/boot/dts/Makefile between commit ba5a37e52194 ("ARM: mvebu: Move
> kirkwood DT boards into mach-mvebu") from the arm-soc tree and commit
> 400550ae7e77 ("ARM: dts: Build all keystone dt blobs") from the keystone
> tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
> 
Looks fine. Thanks

Regards,
Santosh
