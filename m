Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676Ab3FEOPn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 10:15:43 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:54711 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237Ab3FEOPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 10:15:42 -0400
Date: Wed, 5 Jun 2013 10:15:39 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org,
        Samuel Ortiz <sameo@linux.intel.com>, Pawel Moll <pawel.moll@arm.com>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Jon Medhurst <tixy@linaro.org>, Achin Gupta <achin.gupta@arm.com>,
        Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
Subject: Re: [RFC PATCH v2 0/2] drivers: mfd: Versatile Express SPC support
In-Reply-To: <1370432767-6620-1-git-send-email-lorenzo.pieralisi@arm.com>
Message-ID: <alpine.LFD.2.03.1306051008590.1200@syhkavp.arg>
References: <1370432767-6620-1-git-send-email-lorenzo.pieralisi@arm.com>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Jun 2013, Lorenzo Pieralisi wrote:

> This patch is v2 of a previous posting:
> 
> http://lists.infradead.org/pipermail/linux-arm-kernel/2013-May/170624.html
> 
> V2 changes:
> 
> - Dropped timeout interface patch
> - Converted interfaces to non-timeout ones, integrated and retested
> - Removed mutex used at init
> - Refactored code to work around init sections warning
> - Fixed interface type enumeration init
> - Fixed data write in SYSCFG write commands
> 
> This patch series introduces support for the Versatile Express Serial
> Power Controller (SPC) present in ARM Versatile Express TC2 core tiles.
> SPC driver is a fundamental component of TC2 power management and allows
> to carry out C-state management and DVFS for A15 and A7 clusters.
[...]

The MCPM backend for TC2 obviously depends on these patches and it 
should probably be merged via the ARM SoC tree.  Could those patches go 
with it as well?  If so, Samuel's ACK would be appreciated.


Nicolas
