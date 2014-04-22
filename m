Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757226AbaDVQ16 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 12:27:58 -0400
Received: from top.free-electrons.com ([176.31.233.9]:50334 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753001AbaDVQ1y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 12:27:54 -0400
Date: Tue, 22 Apr 2014 18:27:13 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Antoine =?UTF-8?B?VMOpbmFydA==?= 
	<antoine.tenart@free-electrons.com>
Cc: sebastian.hesselbarth@gmail.com, tj@kernel.org, zmxu@marvell.com,
        jszhang@marvell.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        alexandre.belloni@free-electrons.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/6] Documentation: bindings: add the berlin-achi
 compatible to the ahci platform
Message-ID: <20140422182713.0084fd2f@skate>
In-Reply-To: <1398181105-19714-3-git-send-email-antoine.tenart@free-electrons.com>
References: <1398181105-19714-1-git-send-email-antoine.tenart@free-electrons.com>
	<1398181105-19714-3-git-send-email-antoine.tenart@free-electrons.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Antoine Ténart,

On Tue, 22 Apr 2014 17:38:21 +0200, Antoine Ténart wrote:
> The berlin-achi driver allows Berlin SoCs to support their AHCI SATA controller.
> Add the compatible to the device tree bindings documentation.
> 
> Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>

Typo in the commit title: s/achi/ahci.

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
