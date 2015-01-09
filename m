Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933419AbbAIK6A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:58:00 -0500
Received: from mail-ig0-f177.google.com ([209.85.213.177]:47333 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757389AbbAIK56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:57:58 -0500
MIME-Version: 1.0
In-Reply-To: <CAMuHMdVeEmKiqGTOmevaBDbJ=nBTbSi6d6Xrm0eyvbMTtyU=sA@mail.gmail.com>
References: <1418842153-17113-1-git-send-email-geert+renesas@glider.be>
	<CAMuHMdVeEmKiqGTOmevaBDbJ=nBTbSi6d6Xrm0eyvbMTtyU=sA@mail.gmail.com>
Date: Fri, 9 Jan 2015 11:57:57 +0100
X-Google-Sender-Auth: 8z-QJd2o9bpV1inQ-HdQLN73qAE
Message-ID: <CAO3366x64phBJ=tHOK03P6Ok_6LxiyLyC9LhjcocuqTx=86cfA@mail.gmail.com>
Subject: Re: [PATCH v2 0/8] Add Simple Power-Managed Bus Support
From: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Arnd Bergmann <arnd@arndb.de>, Kevin Hilman <khilman@kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 8, 2015 at 8:28 PM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Wed, Dec 17, 2014 at 7:49 PM, Geert Uytterhoeven
> <geert+renesas@glider.be> wrote:
>> The Renesas Bus State Controller (BSC) provides an external bus for
>> connecting multiple external devices to an SoC, driving several chip
>> select lines, for e.g. NOR FLASH, Ethernet and USB.
>> On the kzm9g and ape6evm development boards, an smsc9220 Ethernet
>> controller is connnected to the BSC of an SH-Mobile AG5 (sh73a0) resp.
>> R-Mobile APE6 (r8a73a4) SoC.
>
> [...]
>
>> This was tested on sh73a0/kzm9g-multiplatform. Without this, Ethernet
>> doesn't work, as the ZB clock is disabled by clk_disable_unused().
>> Testing on r8a73a4/ape6evm-multiplatform would be appreciated.
>
> Has anyone tried this on r8a73a4/ape6evm-multiplatform?

Works like a charm.

Tested-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>

CU
Uli
