Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840AbaA3MpK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 07:45:10 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:59820 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbaA3MpJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 07:45:09 -0500
Date: Thu, 30 Jan 2014 13:44:48 +0100
From: Lothar =?UTF-8?B?V2HDn21hbm4=?= <LW@KARO-electronics.de>
To: Heiko =?UTF-8?B?U3TDvGJuZXI=?= <heiko@sntech.de>
Cc: Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [RFC] dtc: add ability to make nodes conditional on them being
 referenced
Message-ID: <20140130134448.682ab850@ipc1.ka-ro>
In-Reply-To: <1578575.rVWgTPdq1W@phil>
References: <1578575.rVWgTPdq1W@phil>
Organization: Ka-Ro electronics GmbH
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Heiko Stübner wrote:
> From: Heiko Stuebner <heiko.stuebner@bqreaders.com>
> 
> On i.MX, which carries a lot of pin-groups of which most are unused on
> individual boards, they noticed that this plehora of nodes also results
> in the runtime-lookup-performance also degrading [0].
> 
> A i.MX-specific solution defining the pingroups in the board files but
> using macros to reference the pingroup-data was not well received
> 
> This patch is trying to solve this issue in a more general way, by
> adding the ability to mark nodes as needing to be referenced somewhere
> in the tree.
> 
> To mark a node a needing to be referenced it must be prefixed with
> /delete-unreferenced/. This makes dtc check the nodes reference-status
> when creating the flattened tree, dropping it if unreferenced.
> 
> For example, the i.MX6SL pingroup
> 
> 	/delete-uneferenced/ pinctrl_ecspi1_1: ecspi1grp-1 {
                 ^^
s/unef/unref/
not really important here, but bad for copy/pasters


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
