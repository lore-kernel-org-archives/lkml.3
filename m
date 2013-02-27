Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760296Ab3B0Qss (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 11:48:48 -0500
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:12198
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758651Ab3B0Qsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 11:48:46 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275ch8275bhz2dh2a8h668h839h944hd24he5bhf0ah1220h1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1155h)
Date: Wed, 27 Feb 2013 10:45:12 -0600
From: Kim Phillips <kim.phillips@freescale.com>
To: Rob Landley <rob@landley.net>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>, Nicolas Pitre <nico@linaro.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] dtc: import latest upstream dtc
Message-ID: <20130227104512.c07c0ade0107aa7f4ec18217@freescale.com>
In-Reply-To: <1361934486.18483.5@driftwood>
References: <1361928975-29395-1-git-send-email-kim.phillips@freescale.com>
	<1361928975-29395-2-git-send-email-kim.phillips@freescale.com>
	<1361934486.18483.5@driftwood>
Organization: Freescale Semiconductor, Inc.
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2013 21:08:06 -0600
Rob Landley <rob@landley.net> wrote:

> On 02/26/2013 07:36:14 PM, Kim Phillips wrote:
> > This updates scripts/dtc to upstream dtc commit 27cdc1b
> 
> There's an upstream for dts?

dtc - the device tree compiler, yes.

> > "Added license header to dtc/libfdt/fdt.h and libfdt_env.h"
> > from git://git.jdl.com/software/dtc.git.
> 
> That git repository has a Documentation directory with for example  
> "dts-format.txt" in it. My current linux git repository does not  
> contain a file called dts-format.txt.

this patch isn't attempting to update dts-format.txt, or any other
file that exists in the upstream dtc project that isn't present -
and used - in the kernel.  The purpose of this patch is to update
libfdt, which has in-kernel users.

Kim

