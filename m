Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789AbaKSL0b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 06:26:31 -0500
Received: from down.free-electrons.com ([37.187.137.238]:37641 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753980AbaKSL0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 06:26:30 -0500
Date: Wed, 19 Nov 2014 12:26:26 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Lior Amsalem <alior@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        linux-kernel@vger.kernel.org, Nadav Haklai <nadavh@marvell.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 0/4] Hot plug support for the Armada 38x SoCs
Message-ID: <20141119122626.7a3ef761@free-electrons.com>
In-Reply-To: <1414669184-16785-1-git-send-email-gregory.clement@free-electrons.com>
References: <1414669184-16785-1-git-send-email-gregory.clement@free-electrons.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Gregory CLEMENT,

On Thu, 30 Oct 2014 12:39:40 +0100, Gregory CLEMENT wrote:

> Gregory CLEMENT (4):
>   ARM: mvebu: Clean-up the Armada XP support
>   ARM: mvebu: Move SCU power up in a function
>   ARM: mvebu: Fix the secondary startup for Cortex A9 SoC
>   ARM: mvebu: Implement the CPU hotplug support for the Armada 38x SoCs

For the entire series:

Tested-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
  (tested on Armada 385 DB)
Reviewed-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

Thanks,

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
