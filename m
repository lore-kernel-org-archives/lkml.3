Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758613AbbA0XDN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 18:03:13 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:48562 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758325AbbA0XDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 18:03:10 -0500
Date: Tue, 27 Jan 2015 15:03:12 -0800
From: Olof Johansson <olof@lixom.net>
To: Baruch Siach <baruch@tkos.co.il>
Cc: arm@kernel.org, Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 0/4] ARM: Conexant Digicolor CX92755 SoC support
Message-ID: <20150127230312.GB11789@quad.lixom.net>
References: <cover.1421219953.git.baruch@tkos.co.il>
 <20150125180855.GA3148@tarshish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150125180855.GA3148@tarshish>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 25, 2015 at 08:08:55PM +0200, Baruch Siach wrote:
> Hi ARM SoC maintainers,
> 
> On Wed, Jan 14, 2015 at 10:40:29AM +0200, Baruch Siach wrote:
> > This series adds initial support for the Conexant CX92755 SoC. The CX92755 is
> > one of the Digicolor series of SoCs, all sharing many of the same peripherals.
> > The code was tested on the CX92755 evaluation kit, AKA Equinox.
> > 
> > Uses attempting to try this code will most likely also want the UART/console
> > driver available from https://patchwork.kernel.org/patch/5515861/.
> 
> Any chance of having this series merged for 3.20? Arnd has acked this already.

Yep, just had a small comment on naming for the third patch, the rest have been
applied now.


-Olof
