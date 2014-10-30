Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161232AbaJ3RnG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 13:43:06 -0400
Received: from down.free-electrons.com ([37.187.137.238]:52816 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934323AbaJ3RnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 13:43:02 -0400
Date: Thu, 30 Oct 2014 18:42:54 +0100
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        gregkh@linuxfoundation.org, Peter.Chen@freescale.com, kishon@ti.com,
        stern@rowland.harvard.edu, alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 1/7] usb: move the OTG state from the USB PHY to the
 OTG structure
Message-ID: <20141030174254.GA6764@kwain>
References: <1414514141-31767-1-git-send-email-antoine.tenart@free-electrons.com>
 <1414514141-31767-2-git-send-email-antoine.tenart@free-electrons.com>
 <20141030163148.GF10130@saruman>
 <20141030163513.GI10130@saruman>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141030163513.GI10130@saruman>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On Thu, Oct 30, 2014 at 11:35:13AM -0500, Felipe Balbi wrote:
> On Thu, Oct 30, 2014 at 11:31:48AM -0500, Felipe Balbi wrote:
> > On Tue, Oct 28, 2014 at 05:35:35PM +0100, Antoine Tenart wrote:
> > > Before using the PHY framework instead of the USB PHY one, we need to
> > > move the OTG state into another place, since it won't be available when
> > > USB PHY isn't used. This patch moves the OTG state into the OTG
> > > structure, and makes all the needed modifications in the drivers
> > > using the OTG state.
> > > 
> > > Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
> > > Acked-by: Peter Chen <peter.chen@freescale.com>
> > 
> > Acked-by: Felipe Balbi <balbi@ti.com>
> 
> Please rebase on my testing/next and I'll take the series. When
> rebasing, then add Peter's Tested-by/Acked-by where they're missing.

I just re-sent the series, rebased on your testing/next branch.

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
