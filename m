Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905AbaA1NCL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 08:02:11 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:50849 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754574AbaA1NCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 08:02:06 -0500
Date: Tue, 28 Jan 2014 13:01:54 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Vinod Koul <vinod.koul@intel.com>, Lars-Peter Clausen <lars@metafoo.de>,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andy Gross <agross@codeaurora.org>,
        dmaengine@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [Patch v3 2/2] dmaengine: qcom_bam_dma: Add device tree binding
Message-ID: <20140128130153.GI15937@n2100.arm.linux.org.uk>
References: <1390890471-14882-1-git-send-email-agross@codeaurora.org> <20140128111756.GE15937@n2100.arm.linux.org.uk> <20140128113242.GJ10628@intel.com> <4916428.f0GtxdkWKj@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4916428.f0GtxdkWKj@wuerfel>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 01:05:10PM +0100, Arnd Bergmann wrote:
> Ok, thanks for clearing up my mistake. However, the argument remains:
> the direction doesn't need to be in the DT DMA descriptor since it
> gets set by software anyway.

Yes - for full-duplex, it's implied, since you have one DMA request
(and therefore virtual channel) for memory-to-device and another for
device-to-memory.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
