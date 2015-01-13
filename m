Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278AbbAMXJq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 18:09:46 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52116 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbbAMXJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 18:09:45 -0500
Date: Tue, 13 Jan 2015 15:09:56 -0800
From: Olof Johansson <olof@lixom.net>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, ARM Maintainers <arm@kernel.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: re-fromat AT91 part to match other entries
Message-ID: <20150113230956.GA15087@quad.lixom.net>
References: <20150112224203.GL22090@quad.lixom.net>
 <1421160180-23452-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421160180-23452-1-git-send-email-nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 03:43:00PM +0100, Nicolas Ferre wrote:
> The entries are separated as ARM V4/V5 and ARM V7 as some other per-SoC config
> options may be removed in the near future.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
> Hi Olof,
> 
> This is an attempt to match other ARM SoC families format.
> If you feel that the patch can be good, do not hesitate to take it yourself. I
> don't plan to integrate it in any of my pull-request so it can appear quickly in
> arm-soc and can be used by everyone.

Hi,

If you see what Peter did, he split up the rules per-SoC based on how
things were selectable in Kconfig. Since you seem to have the Kconfig
entries already, how about doing the same? That way the same information
w.r.t. SoC family that you have as comments isn't lost either.


-Olof
