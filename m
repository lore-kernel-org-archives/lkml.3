Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622AbaHTQA1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 12:00:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51535 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751494AbaHTQA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 12:00:26 -0400
Message-ID: <53F4C615.9060908@suse.de>
Date: Wed, 20 Aug 2014 18:00:21 +0200
From: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH 2/3] ARM: zynq: DT: Move size/address properties to dtsi
References: <1408550219-19825-1-git-send-email-soren.brinkmann@xilinx.com> <1408550219-19825-2-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1408550219-19825-2-git-send-email-soren.brinkmann@xilinx.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 20.08.2014 17:56, schrieb Soren Brinkmann:
> Move the GEM's size and address cells properties to the common
> dtsi file.
> 
> Cc: Andreas Färber <afaerber@suse.de>
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
>  arch/arm/boot/dts/zynq-7000.dtsi      | 4 ++++
>  arch/arm/boot/dts/zynq-parallella.dts | 2 --
>  2 files changed, 4 insertions(+), 2 deletions(-)

Reviewed-by: Andreas Färber <afaerber@suse.de>

Regards,
Andreas

-- 
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 16746 AG Nürnberg
