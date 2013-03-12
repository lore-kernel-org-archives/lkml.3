Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932090Ab3CLCMU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 22:12:20 -0400
Received: from host-176-100-244-43.masterbit.su ([176.100.244.43]:54862 "EHLO
	tservice.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754601Ab3CLCMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 22:12:19 -0400
Date: Tue, 12 Mar 2013 06:12:18 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Fabio Estevam <festevam@gmail.com>
Cc: gregkh@linuxfoundation.org, s.hauer@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH 1/2] w1: mxc_w1: Convert to devm_ioremap_resource()
Message-ID: <20130312021218.GC8181@ioremap.net>
References: <1363043896-16140-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363043896-16140-1-git-send-email-festevam@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Mon, Mar 11, 2013 at 08:18:15PM -0300, Fabio Estevam (festevam@gmail.com) wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> According to Documentation/driver-model/devres.txt:
> 
>   devm_request_and_ioremap() : obsoleted by devm_ioremap_resource()
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Both patches look good to me, thank you
Greg, please pull it into you tree

Acked-by: Evgeniy Polyakov <zbr@ioremap.net>

-- 
	Evgeniy Polyakov
