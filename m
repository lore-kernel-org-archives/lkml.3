Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152AbaHCDYQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 23:24:16 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:58298 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706AbaHCDYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 23:24:14 -0400
Date: Sat, 2 Aug 2014 20:24:42 -0700
From: Olof Johansson <olof@lixom.net>
To: Roger Quadros <rogerq@ti.com>
Cc: arm@kernel.org, tony@atomide.com, kishon@ti.com, balbi@ti.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [REBASED PATCH] ARM: multi_v7_defconfig: Enable TI PIPE3 PHY
 driver
Message-ID: <20140803032442.GA16641@quad.lixom.net>
References: <1406540737-9493-1-git-send-email-rogerq@ti.com>
 <1406625328-26112-1-git-send-email-rogerq@ti.com>
 <20140730195242.GF18384@quad.lixom.net>
 <53DB7910.1010808@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53DB7910.1010808@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2014 at 02:25:04PM +0300, Roger Quadros wrote:
> From: Roger Quadros <rogerq@ti.com>
> 
> This driver is needed by SATA, PCIe and USB modules on TI SoCs.
> 
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> Acked-by: Tony Lindgren <tony@atomide.com>

Thanks, applied.


-Olof
