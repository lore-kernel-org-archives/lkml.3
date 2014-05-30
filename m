Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933265AbaE3N4r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 09:56:47 -0400
Received: from zougloub.eu ([198.27.83.45]:55081 "EHLO zougloub.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753137AbaE3N4p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 09:56:45 -0400
Date: Fri, 30 May 2014 09:58:22 -0400
From: =?UTF-8?B?SsOpcsO0bWU=?= Carretero <cJ-ko@zougloub.eu>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Tejun Heo <tj@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: Bad DMA from Marvell 9230
Message-ID: <20140530095822.3588a6ff@Vantage>
In-Reply-To: <1401446278.14938.26.camel@pasglop>
References: <1395903457.5569.89.camel@pasglop>
	<20140530030618.5ad4f447@Vantage>
	<1401446278.14938.26.camel@pasglop>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 May 2014 20:37:58 +1000
Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> We've switched to a 9235 instead which seems to work fine.

Weird (I hadn't seen that you reported the 9235 working...), I have
IOMMU problems with a 9235...

What system are you running it on (when you say "power box", is it a
beefy x86 computer or literally a PowerPC)?
For me, AMD 990FX chipset, latest master linux.
My board works fine* on another non-IOMMU system.

-- 
Jérôme

* with issues with port multipliers

Link to Benjamin's first message: https://lkml.org/lkml/2014/3/27/43
