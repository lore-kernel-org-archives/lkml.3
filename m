Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522AbaLOHCz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 02:02:55 -0500
Received: from plane.gmane.org ([80.91.229.3]:53256 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbaLOHCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 02:02:53 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Subject: Re: [PATCH] ARM: pxa: lubbock: use new cottula driver
Date: Mon, 15 Dec 2014 07:02:39 +0000 (UTC)
Message-ID: <m6m12f$4uu$1@ger.gmane.org>
References: <1418598738-21449-1-git-send-email-robert.jarzmik@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: ppp78-37-149-215.pppoe.avangarddsl.ru
User-Agent: Pan/0.139 (Sexual Chocolate; GIT bf56508
 git://git.gnome.org/pan2)
Cc: linux-arm-kernel@lists.infradead.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Dec 2014 00:12:18 +0100, Robert Jarzmik wrote:

> As the interrupt handling was transferred to the cottula driver, make
> the switch in lubbock platform code.

As the pxa25x itself is named Cotulla, the 'cottula' doesn't look like
a good name for FPGA irq driver.

> 
> Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>

-- 
With best wishes
Dmitry


