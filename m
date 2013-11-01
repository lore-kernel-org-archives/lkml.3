Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab3KAQCL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 12:02:11 -0400
Received: from 8bytes.org ([85.214.48.195]:38526 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752698Ab3KAQCK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 12:02:10 -0400
Date: Fri, 1 Nov 2013 17:02:06 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: iommu@lists.linux-foundation.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: VT-d and x2apic: broken resume after suspend to ram
Message-ID: <20131101160206.GM17455@8bytes.org>
References: <CA+MoWDqoBxuFhBsf_rVBT1C8=mwj02hXgPfuWnjY4yeVa-84cA@mail.gmail.com>
 <20131101130702.GA3348@8bytes.org>
 <CA+MoWDoDTFarOLUHgNmUFksRvV-R+7jufUwLbsS8ecaO+_m2kQ@mail.gmail.com>
 <20131101142115.GK17455@8bytes.org>
 <CA+MoWDq4jYCD9zGaPA_Z4AL3Rj6hu4-rMEofn=8uWEGP6Tdruw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+MoWDq4jYCD9zGaPA_Z4AL3Rj6hu4-rMEofn=8uWEGP6Tdruw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Fri Nov  1 17:02:08 2013
X-DSPAM-Confidence: 0.9993
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5273d08020861225120852
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 01, 2013 at 04:47:47PM +0100, Peter Senna Tschudin wrote:
> Only serial ports over USB:
> usb 2-1.3.2: pl2303 converter now attached to ttyUSB0
> 
> The issue with no_console_suspend is that the monitor is powered off
> on suspend and never resume after that. The external monitor enters in
> power save mode during suspend and also never resume. Do you know if
> replacing my wifi/bt card by this:
> 
> http://www.startech.com/Cards-Adapters/Serial-Cards-Adapters/2-Port-RS232-Mini-PCI-Express-Serial-Card-16950-UART~MPEX2S952
> 
> would enable to use the serial console for seeing kernel debug messages?

Who knows, depends on the BIOS in your machine, I guess. But I would say
there is a at least a better chance with this than with a USB-Serial
adapter.


	Joerg


