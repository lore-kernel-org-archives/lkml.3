Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352Ab3GYJpA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 05:45:00 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:40959 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753142Ab3GYJo5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 05:44:57 -0400
Message-ID: <51F0F377.1060204@ti.com>
Date: Thu, 25 Jul 2013 15:14:23 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
CC: <davinci-linux-open-source@linux.davincidsp.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <kernel@savoirfairelinux.com>
Subject: Re: [RFC] ARM: davinci: da850: add a few pinmux definitions
References: <1374610382-11204-1-git-send-email-vivien.didelot@savoirfairelinux.com>
In-Reply-To: <1374610382-11204-1-git-send-email-vivien.didelot@savoirfairelinux.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivien,

On Wednesday 24 July 2013 01:43 AM, Vivien Didelot wrote:
> This patch adds some pinmux definitions that we needed, such as SPI0,
> SPI1 and some GPIO.
> 
> Note: I sent the patch as an RFC because I would like a confirmation for the
> appropriate name for SPI*_SCS* and EMA_A_RW pinmuxes.
> 
> Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>

Why do you need to add these definitions? If it is for a new platform
you are working on, then it should be supported using DT, in which case
we use the pinctrl-single driver and define the muxing needed in
.dts/.dtsi files.

Thanks,
Sekhar

