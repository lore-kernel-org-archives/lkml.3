Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759311AbaJ3Lnq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 07:43:46 -0400
Received: from down.free-electrons.com ([37.187.137.238]:50093 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758890AbaJ3Lno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 07:43:44 -0400
Date: Thu, 30 Oct 2014 12:43:41 +0100
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: Peter.Chen@freescale.com
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] usb: chipidea: setup ci_hdrc_platform_data in core
 driver
Message-ID: <20141030114341.GA7798@kwain>
References: <1414669007-9850-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1414669007-9850-1-git-send-email-antoine.tenart@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 12:36:41PM +0100, Antoine Tenart wrote:
> Hello,
> 
> This series introduce the ci_hdrc_get_platdata function to help setting up the
> ChipIdea internal ci_hdrc_platform_data structure. This helps avoiding
> duplicating code.
> 
> This series comes from a duscission on Berlin's USB pacthes where it was asked
> to move the PHY phandle handling in the ChipIdea core[1].
> 
> With the introduction of the ci_hdrc_get_platdata function, the old
> ci_get_platdata function is removed. Changes in ChipIdea drivers have also been
> made.
> 
> This series is needed for the Berlin USB support and has been tested with an
> updated version of the USB Berlin driver (not in mainline yet).
> 
> Thanks,
> 
> Antoine
> 
> [1] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-October/292383.html
> 

Of course, this is the cover letter so it should be [PATCH 0/6].

This series depends on the generic PHY framework support in USB and CI:
https://lkml.org/lkml/2014/10/28/807


Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
