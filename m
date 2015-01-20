Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143AbbATIni (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 03:43:38 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:35473 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbbATIng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 03:43:36 -0500
Date: Tue, 20 Jan 2015 16:42:49 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Stefan Agner <stefan@agner.ch>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: vf610: use zero based naming for GPIO nodes
Message-ID: <20150120084247.GZ2766@dragon>
References: <1421427975-16391-1-git-send-email-stefan@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421427975-16391-1-git-send-email-stefan@agner.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2015 at 06:06:15PM +0100, Stefan Agner wrote:
> On Vybrid, all peripherals are numbered starting with zero,
> including the GPIO and PORT module. However, the labels of the
> corresponding device tree nodes start with one, which is confusing.
> Fix that by renaming the labels of the gpio nodes in the device
> tree.
> 
> Signed-off-by: Stefan Agner <stefan@agner.ch>

Yep, this makes sense since Vybrid Reference Manual is numbering GPIO
port from 0.

Applied, thanks.
