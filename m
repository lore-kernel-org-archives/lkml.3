Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934648AbaHZKQC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 06:16:02 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:56387 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934453AbaHZKQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 06:16:00 -0400
Message-ID: <53FC5E40.7020904@ti.com>
Date: Tue, 26 Aug 2014 15:45:28 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>, <khilman@deeprootsystems.com>
CC: <linux@arm.linux.org.uk>, <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] ARM: davinci: board-da850-evm: Add needed regulators
 for tlv320aic3106 codec
References: <1406546678-797-1-git-send-email-peter.ujfalusi@ti.com> <1406546678-797-2-git-send-email-peter.ujfalusi@ti.com>
In-Reply-To: <1406546678-797-2-git-send-email-peter.ujfalusi@ti.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 July 2014 04:54 PM, Peter Ujfalusi wrote:
> IOVDD: tps65070's dcdc2
> AVDD and DRVDD: fixed regulator derived from 5V via TPS73701DCQ
> DVDD: fixed regulator derived from 5V via TPS73701DCQ
> 
> This patch needed to be able to probe the audio codec.
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> ---
>  arch/arm/mach-davinci/board-da850-evm.c | 13 +++++++++++++

Applied both for v3.18 while fixing the following:

CHECK: Please use a blank line after function/struct/union/enum declarations
#56: FILE: arch/arm/mach-davinci/board-da850-evm.c:845:
 }
+/* Fixed regulator support */

total: 0 errors, 0 warnings, 1 checks, 37 lines checked

Thanks,
Sekhar

