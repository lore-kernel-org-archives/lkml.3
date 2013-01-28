Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab3A1PhU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 10:37:20 -0500
Received: from 8bytes.org ([85.214.48.195]:52986 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751757Ab3A1PhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 10:37:03 -0500
Date: Mon, 28 Jan 2013 16:36:56 +0100
From: Joerg Roedel <joro@8bytes.org>
To: "Kinney, Steven" <Steven.Kinney@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Myron Stowe <myron.stowe@redhat.com>, Hiroshi DOYU <hdoyu@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>, Jiri Kosina <jkosina@suse.cz>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Thomas Renninger <trenn@suse.de>, Andi Kleen <ak@linux.intel.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: Re: [PATCH 1/3] AMD x86 quirks: Quirk for enabling IOMMUv2 PC feature
Message-ID: <20130128153656.GA25591@8bytes.org>
References: <1358799658-6236-1-git-send-email-steven.kinney@amd.com>
 <1358799658-6236-2-git-send-email-steven.kinney@amd.com>
 <20130128142928.GZ25591@8bytes.org>
 <57D41218901B4442B4AFF404D21591163C2D4E@sausexdag02.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57D41218901B4442B4AFF404D21591163C2D4E@sausexdag02.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Mon Jan 28 16:37:01 2013
X-DSPAM-Confidence: 0.9995
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 51069b1d22973669613196
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 02:59:25PM +0000, Kinney, Steven wrote:
> Testing with perf shows expected results.

Can you give me an impression on how the results look like when perf is
used? Since the hardware is widely available yet I can't try this
myself.


	Joerg


