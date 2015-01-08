Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388AbbAHWvJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 17:51:09 -0500
Received: from galahad.ideasonboard.com ([185.26.127.97]:44095 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516AbbAHWvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 17:51:07 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Ulrich Hecht <ulrich.hecht+renesas@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Kevin Hilman <khilman@kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/8] Add Simple Power-Managed Bus Support
Date: Fri, 09 Jan 2015 00:51:23 +0200
Message-ID: <10372546.9gL7hIlFWP@avalon>
User-Agent: KMail/4.14.3 (Linux/3.17.7-gentoo; KDE/4.14.3; x86_64; ; )
In-Reply-To: <CAMuHMdVeEmKiqGTOmevaBDbJ=nBTbSi6d6Xrm0eyvbMTtyU=sA@mail.gmail.com>
References: <1418842153-17113-1-git-send-email-geert+renesas@glider.be> <CAMuHMdVeEmKiqGTOmevaBDbJ=nBTbSi6d6Xrm0eyvbMTtyU=sA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On Thursday 08 January 2015 20:28:45 Geert Uytterhoeven wrote:
> On Wed, Dec 17, 2014 at 7:49 PM, Geert Uytterhoeven wrote:
> > The Renesas Bus State Controller (BSC) provides an external bus for
> > connecting multiple external devices to an SoC, driving several chip
> > select lines, for e.g. NOR FLASH, Ethernet and USB.
> > On the kzm9g and ape6evm development boards, an smsc9220 Ethernet
> > controller is connnected to the BSC of an SH-Mobile AG5 (sh73a0) resp.
> > R-Mobile APE6 (r8a73a4) SoC.
> 
> [...]
> 
> > This was tested on sh73a0/kzm9g-multiplatform. Without this, Ethernet
> > doesn't work, as the ZB clock is disabled by clk_disable_unused().
> > Testing on r8a73a4/ape6evm-multiplatform would be appreciated.
> 
> Has anyone tried this on r8a73a4/ape6evm-multiplatform?

I'm afraid I can't help there, as I have no APE6EVM board.

-- 
Regards,

Laurent Pinchart

