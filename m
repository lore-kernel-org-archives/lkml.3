Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691AbaGOP0X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 11:26:23 -0400
Received: from top.free-electrons.com ([176.31.233.9]:55323 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755613AbaGOP0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 11:26:16 -0400
Date: Tue, 15 Jul 2014 17:24:37 +0200
From: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
To: punnaiah choudary kalluri <punnaia@xilinx.com>
Cc: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        sebastian.hesselbarth@gmail.com, Peter Chen <Peter.Chen@freescale.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 07/12] usb: chipidea: add a generic driver
Message-ID: <20140715152437.GF1011@kwain>
References: <1403606121-6368-1-git-send-email-antoine.tenart@free-electrons.com>
 <1403606121-6368-8-git-send-email-antoine.tenart@free-electrons.com>
 <CAGnW=BbA3gLdSv8AKkD_ysnYAaN0KoCdVW+wxWPB9zzGCh9+jQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGnW=BbA3gLdSv8AKkD_ysnYAaN0KoCdVW+wxWPB9zzGCh9+jQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jul 03, 2014 at 08:17:34AM +0530, punnaiah choudary kalluri wrote:
> Since its a generic driver, support for configuring the dma_mask using
> dma_coerce_mask_and_coherent would be good.
> 

Should I add a DMA mask dt property? Or just not add this and wait for
someone needing it in his case?

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
