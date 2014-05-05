Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403AbaEEUws (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 16:52:48 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:58353 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755485AbaEEUwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 16:52:46 -0400
Date: Mon, 5 May 2014 13:52:51 -0700
From: Olof Johansson <olof@lixom.net>
To: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
Cc: sebastian.hesselbarth@gmail.com, arm@kernel.org,
        alexandre.belloni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: multi_v7_defconfig: select CONFIG_GPIO_DWAPB
Message-ID: <20140505205251.GF27961@quad.lixom.net>
References: <1397724150-14055-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1397724150-14055-1-git-send-email-antoine.tenart@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 10:42:30AM +0200, Antoine Ténart wrote:
> The newly integrated dwapb gpio driver handles the Berlin SoCs GPIOs.
> Add this driver to the multi_v7_defconfig.
> 
> Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
> ---
>  This patch applies on top of Alexandre's one selecting
>  CONFIG_MACH_BERLIN_BG2Q:
>  https://patchwork.kernel.org/patch/3876171/

Applied.

-Olof
