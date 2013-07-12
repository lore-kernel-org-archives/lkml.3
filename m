Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965285Ab3GLSEW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 14:04:22 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:51787 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964906Ab3GLSEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 14:04:20 -0400
Date: Fri, 12 Jul 2013 11:04:20 -0700
From: Olof Johansson <olof@lixom.net>
To: vstehle@debian
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org,
        Vincent =?iso-8859-1?Q?Stehl=E9?= <vincent.stehle@freescale.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH linux-next] arm: multi_v7_defconfig: add fsl lpuart
 serial console
Message-ID: <20130712180420.GA28285@quad.lixom.net>
References: <1373392491-32056-1-git-send-email-vincent.stehle@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1373392491-32056-1-git-send-email-vincent.stehle@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 09, 2013 at 07:54:51PM +0200, Vincent Stehlé wrote:
> Add Freescale LPUART serial console support. This gives us the boot messages on
> UART on e.g. the Vybrid VF610 Tower board.
> 
> Signed-off-by: Vincent Stehlé <vincent.stehle@freescale.com>
> Cc: Olof Johansson <olof@lixom.net>
> Cc: Russell King <linux@arm.linux.org.uk>
> ---
> 
> 
> Hi,
> 
> Would you please consider adding LPUART for ARM multi_v7_defconfig, please?
> 
> (This patch is built on top of the following patches:
> http://comments.gmane.org/gmane.linux.kernel/1519712)
> 
> Best regards,

Thanks, applied to fixes. Note that I squashed together the three patches to
one though.


-Olof
