Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758933Ab3BGQMl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 11:12:41 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:63610 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755656Ab3BGQMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 11:12:37 -0500
Date: Thu, 7 Feb 2013 08:08:55 -0800
From: Anton Vorontsov <anton@enomsg.org>
To: Andreas Larsson <andreas@gaisler.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        spi-devel-general@lists.sourceforge.net,
        Mingkai Hu <Mingkai.hu@freescale.com>,
        Joakim Tjernlund <Joakim.Tjernlund@transmode.se>,
        Kumar Gala <galak@kernel.crashing.org>,
        Peter Korsgaard <jacmet@sunsite.dk>, linux-kernel@vger.kernel.org,
        software@gaisler.com
Subject: Re: [PATCH v2 0/7] spi: spi-fsl-spi: Make spi-fsl-spi usable in cpu
 mode outside of FSL SOC environments and add a grlib variant normally
 running on sparc
Message-ID: <20130207160854.GA20979@lizard.gateway.2wire.net>
References: <1360242731-13700-1-git-send-email-andreas@gaisler.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1360242731-13700-1-git-send-email-andreas@gaisler.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2013 at 02:12:04PM +0100, Andreas Larsson wrote:
> This makes the cpu mode of the driver available outside of an FSL SOC
> and even powerpc environment. Furthermore, this adds support for the
> mostly register-compatible SPICTRL core from the GRLIB VHDL IP core
> library normally running on SPARC.

The patches look clean and neat, I don't see anything obviously wrong with
them... so,

Acked-by: Anton Vorontsov <anton@enomsg.org>

Thanks!

Anton
