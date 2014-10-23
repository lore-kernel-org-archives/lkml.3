Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817AbaJWSoc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 14:44:32 -0400
Received: from down.free-electrons.com ([37.187.137.238]:34642 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755221AbaJWSob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 14:44:31 -0400
Date: Thu, 23 Oct 2014 20:41:00 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] ARM: mvebu: Clean-up the Armada XP support
Message-ID: <20141023204100.7cd93f08@free-electrons.com>
In-Reply-To: <1414088070-12510-2-git-send-email-gregory.clement@free-electrons.com>
References: <1414088070-12510-1-git-send-email-gregory.clement@free-electrons.com>
	<1414088070-12510-2-git-send-email-gregory.clement@free-electrons.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Gregory CLEMENT,

On Thu, 23 Oct 2014 20:14:27 +0200, Gregory CLEMENT wrote:

> +/*
> + * The following field (.smp) is stil needed to ensure backward

stil -> still

> + * compatibility with the old device trees

It would be good to be more specific here:

	The following field (.smp) is still needed to ensure backward
	compatibility with old Device Trees that were not specifying
	the cpus enable-method property.

Other than that, looks good to me.

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
