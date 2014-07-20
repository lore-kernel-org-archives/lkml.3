Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790AbaGTKAA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 06:00:00 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:45303 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751395AbaGTJ77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 05:59:59 -0400
Date: Sun, 20 Jul 2014 10:59:46 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Nick Krause <xerofoify@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        robh+dt@kernel.org, nsekhar@ti.com, peter.ujfalusi@ti.com,
        joelf@ti.com, vinod.koul@intel.com,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Edma.c: Fix Mes
Message-ID: <20140720095945.GE21766@n2100.arm.linux.org.uk>
References: <CAPDOMVhd-mfNfT+DbHWbzQA8sb3xpqW6a0WEuTTeCGyK8+kRNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPDOMVhd-mfNfT+DbHWbzQA8sb3xpqW6a0WEuTTeCGyK8+kRNQ@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 20, 2014 at 12:27:37AM -0400, Nick Krause wrote:
> Hey Russell and others,
> Sorry to bug you again but I have a fix questions before I clean up
> the fix mes in this file.
> Is edma_clean_channel needed or is edma_stop good enough?  And do  we
> CCERR.BIT(16)
> need to write this bit or not?

I have no idea.  That's why I'm not trying to fix it; it's best left
alone unless you know for certain how to fix it _and_ that you can
fix it _correctly_.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
