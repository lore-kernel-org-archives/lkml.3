Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478AbbA0XCV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 18:02:21 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:65442 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755888AbbA0XCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 18:02:17 -0500
Date: Tue, 27 Jan 2015 15:02:18 -0800
From: Olof Johansson <olof@lixom.net>
To: Baruch Siach <baruch@tkos.co.il>
Cc: arm@kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 2/4] ARM: digicolor: add low level debug support
Message-ID: <20150127230218.GC11263@quad.lixom.net>
References: <cover.1421219953.git.baruch@tkos.co.il>
 <5b6342c716e2e56da34d7a518b49817967de948a.1421219953.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b6342c716e2e56da34d7a518b49817967de948a.1421219953.git.baruch@tkos.co.il>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 10:40:31AM +0200, Baruch Siach wrote:
> Use the USART peripheral as UART for low level debug. Only the UA0 port is
> currently supported.
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> ---
>  arch/arm/Kconfig.debug             | 12 ++++++++++--
>  arch/arm/include/debug/digicolor.S | 35 +++++++++++++++++++++++++++++++++++
>  2 files changed, 45 insertions(+), 2 deletions(-)
>  create mode 100644 arch/arm/include/debug/digicolor.S

Applied, thanks.

-Olof
