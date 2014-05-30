Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934508AbaE3U7a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 16:59:30 -0400
Received: from gate.crashing.org ([63.228.1.57]:37117 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932699AbaE3U71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 16:59:27 -0400
Message-ID: <1401483550.14938.37.camel@pasglop>
Subject: Re: Bad DMA from Marvell 9230
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: =?ISO-8859-1?Q?J=E9r=F4me?= Carretero <cJ-ko@zougloub.eu>
Cc: Tejun Heo <tj@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>
Date: Sat, 31 May 2014 06:59:10 +1000
In-Reply-To: <20140530095822.3588a6ff@Vantage>
References: <1395903457.5569.89.camel@pasglop>
	 <20140530030618.5ad4f447@Vantage> <1401446278.14938.26.camel@pasglop>
	 <20140530095822.3588a6ff@Vantage>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-05-30 at 09:58 -0400, Jérôme Carretero wrote:
> Weird (I hadn't seen that you reported the 9235 working...), I have
> IOMMU problems with a 9235...
> 
> What system are you running it on (when you say "power box", is it a
> beefy x86 computer or literally a PowerPC)?
> For me, AMD 990FX chipset, latest master linux.
> My board works fine* on another non-IOMMU system.

A PowerPC POWER8 prototype machine :-)

Cheers,
Ben.


