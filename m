Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab3CCJYr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 04:24:47 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:55326 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978Ab3CCJXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 04:23:03 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v5 01/16] spi/spi-atmel: fix master->num_chipselect wrongly set.
To: Wenyou Yang <wenyou.yang@atmel.com>, linux-arm-kernel@lists.infradead.org
Cc: nicolas.ferre@atmel.com, plagnioj@jcrosoft.com, richard.genoud@gmail.com,
        JM.Lin@atmel.com, wenyou.yang@atmel.com,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <1361861289-30332-2-git-send-email-wenyou.yang@atmel.com>
References: <1361861289-30332-1-git-send-email-wenyou.yang@atmel.com> <1361861289-30332-2-git-send-email-wenyou.yang@atmel.com>
Date: Sat, 02 Mar 2013 23:15:35 +0000
Message-Id: <20130302231535.8E6043E35BE@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2013 14:47:54 +0800, Wenyou Yang <wenyou.yang@atmel.com> wrote:
> if the spi property "cs-gpios" is set as below:
> 
> 	cs-gpios = <0>, <&pioC 11 0>, <0>, <0>;
> 
> the master->num_chipselect will wrongly be set to 0,
> and the spi fail to probe.
> 
> Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
> Cc: spi-devel-general@lists.sourceforge.net
> Cc: linux-kernel@vger.kernel.org

I think I've got this bug fixed in the core spi code. Give it a couple
of days and retest with linux-next.

g.

