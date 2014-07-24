Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750910AbaGXEBC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 00:01:02 -0400
Received: from guitar.tcltek.co.il ([192.115.133.116]:48098 "EHLO
	mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720AbaGXEBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 00:01:00 -0400
Date: Thu, 24 Jul 2014 07:00:51 +0300
From: Baruch Siach <baruch@tkos.co.il>
To: Benoit Masson <yahoo@perenite.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        gregory.clement@free-electrons.com, andrew@lunn.ch,
        sebastian.hesselbarth@googlemail.com, jason@lakedaemon.net
Subject: Re: [PATCH 2/2] ARM: mvebu: Added dts defintion for Lenovo Iomega
 ix4-300d NAS
Message-ID: <20140724040051.GL2478@tarshish>
References: <1406155973-13657-1-git-send-email-yahoo@perenite.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406155973-13657-1-git-send-email-yahoo@perenite.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benoit,

On Wed, Jul 23, 2014 at 03:52:53PM -0700, Benoit Masson wrote:
> The Lenovo Iomega ix4-300d is a 4-Bay sata NAS with dual Gb,
>  USB2.0 & 3.0, powered by a Marvell Armada XP MV78230 dual core CPU.
> 
> http://shop.lenovo.com/fr/fr/servers/network-storage/lenovoemc/ix4-300d/

I guess most users would prefer an English URL:
http://shop.lenovo.com/us/en/servers/network-storage/lenovoemc/ix4-300d/

Also, the accepted convention is to add a blank line between the commit log 
body and the Signed-off-by line.

> Signed-off-by: Benoit Masson <yahoo@perenite.com>

baruch

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
