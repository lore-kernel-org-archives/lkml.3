Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964998Ab3DIHUP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 03:20:15 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:49978 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964959Ab3DIHUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 03:20:10 -0400
Message-ID: <5163C118.5000207@ti.com>
Date: Tue, 9 Apr 2013 09:19:52 +0200
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130408 Thunderbird/17.0.5
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Tony Lindgren <tony@atomide.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Felipe Balbi <balbi@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Peter Meerwald <pmeerw@pmeerw.net>
Subject: Re: [RFC v2] dmaengine: omap-dma: Start DMA without delay for cyclic
 channels
References: <1364987862-14597-1-git-send-email-peter.ujfalusi@ti.com> <51626D88.8020809@ti.com> <20130408170956.GX30923@n2100.arm.linux.org.uk>
In-Reply-To: <20130408170956.GX30923@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2013 07:09 PM, Russell King - ARM Linux wrote:
> Now that I'm back from a short 4 day break, then yes, and the answer is
> that it's fine.  Who's handling the patch?

Thank you,
Péter
