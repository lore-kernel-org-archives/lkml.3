Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab3EVATR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 20:19:17 -0400
Received: from order.stressinduktion.org ([87.106.68.36]:53846 "EHLO
	order.stressinduktion.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328Ab3EVATP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 20:19:15 -0400
Date: Wed, 22 May 2013 02:19:14 +0200
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: Peter Huewe <peterhuewe@gmx.de>
Cc: "David S. Miller" <davem@davemloft.net>, Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>, Joe Perches <joe@perches.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Patrick McHardy <kaber@trash.net>,
        "open list:ATLX ETHERNET DRI..." <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/19] net/ethernet/atheros/atl1e/atl1e_main: Use module_pci_driver to register driver
Message-ID: <20130522001914.GA9495@order.stressinduktion.org>
Mail-Followup-To: Peter Huewe <peterhuewe@gmx.de>,
	"David S. Miller" <davem@davemloft.net>,
	Jay Cliburn <jcliburn@gmail.com>,
	Chris Snook <chris.snook@gmail.com>, Joe Perches <joe@perches.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Patrick McHardy <kaber@trash.net>,
	"open list:ATLX ETHERNET DRI..." <netdev@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
References: <1369176146-19383-1-git-send-email-peterhuewe@gmx.de> <1369176146-19383-3-git-send-email-peterhuewe@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1369176146-19383-3-git-send-email-peterhuewe@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 12:42:08AM +0200, Peter Huewe wrote:
> Removing some boilerplate by using module_pci_driver instead of calling
> register and unregister in the otherwise empty init/exit functions.
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>

Acked-by: Hannes Frederic Sowa <hannes@stressinduktion.org>

