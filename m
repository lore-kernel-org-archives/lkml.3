Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836Ab3CLXYP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 19:24:15 -0400
Received: from mail-ia0-f180.google.com ([209.85.210.180]:37112 "EHLO
	mail-ia0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755587Ab3CLXYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 19:24:14 -0400
Date: Tue, 12 Mar 2013 16:24:10 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Fabio Estevam <festevam@gmail.com>
Cc: zbr@ioremap.net, s.hauer@pengutronix.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH 2/2] ARM: imx_v6_v7_defconfig: Select CONFIG_W1_MASTER_MXC
Message-ID: <20130312232410.GA29152@kroah.com>
References: <1363043896-16140-1-git-send-email-festevam@gmail.com>
 <1363043896-16140-2-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363043896-16140-2-git-send-email-festevam@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 08:18:16PM -0300, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> Select CONFIG_W1_MASTER_MXC.

Why?  Don't tell me what you did, that's obvious, it's the story that is
needed.

dropped from my queue.

greg k-h
