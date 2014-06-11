Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbaFKIhB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 04:37:01 -0400
Received: from top.free-electrons.com ([176.31.233.9]:59675 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752571AbaFKIgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 04:36:35 -0400
Date: Wed, 11 Jun 2014 10:36:30 +0200
From: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com, tj@kernel.org, kishon@ti.com
Cc: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-ide@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 0/7] ARM: berlin: add AHCI support
Message-ID: <20140611083630.GA32216@kwain>
References: <1401115908-2742-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1401115908-2742-1-git-send-email-antoine.tenart@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

On Mon, May 26, 2014 at 04:51:41PM +0200, Antoine Ténart wrote:
> This series adds the support for Berlin SoC AHCI controller. The
> controller allows to use the SATA host interface and, for example, the
> eSATA port on the BG2Q.
> 
> The series adds a PHY driver to control the two SATA ports available,
> and adds a generic compatible to use the existing ahci_platform driver.
> 
> Also enable the eSATA interface on the BG2Q DMP.

Any news on this series?


Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
