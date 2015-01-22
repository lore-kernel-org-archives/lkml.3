Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601AbbAVIju (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 03:39:50 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49518 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbbAVIjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 03:39:45 -0500
Message-ID: <1421915978.3084.8.camel@pengutronix.de>
Subject: Re: [PATCH v2] gpu: ipu-v3: wait_for_completion_timeout does not
 return negative status
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Lucas Stach <l.stach@pengutronix.de>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Antoine Schweitzer-Chaput <antoine@schweitzer-chaput.fr>,
        linux-kernel@vger.kernel.org
Date: Thu, 22 Jan 2015 09:39:38 +0100
In-Reply-To: <1421667491-8935-1-git-send-email-der.herr@hofr.at>
References: <1421667491-8935-1-git-send-email-der.herr@hofr.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 19.01.2015, 12:38 +0100 schrieb Nicholas Mc Guire:
> Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
> ---
> 
> This fixes up the return value handling and the return type
>
> Patch is against 3.19.0-rc3 -next-20150109                                    
>                                                                                
> This patch was compiletested with imx_v6_v7_defconfig +                       
> CONFIG_RESET_CONTROLLER=y, CONFIG_IMX_IPUV3_CORE=m                            
> 
> Incorrect return type reported by Philipp Zabel <p.zabel@pengutronix.de>

Thank you, I have queued this patch.

regards
Philipp


