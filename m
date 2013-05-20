Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011Ab3ETHS1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 03:18:27 -0400
Received: from lan.nucleusys.com ([92.247.61.126]:49227 "EHLO
	zztop.nucleusys.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751362Ab3ETHSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 03:18:25 -0400
Date: Mon, 20 May 2013 10:18:17 +0300 (EEST)
From: Petko Manolov <petkan@nucleusys.com>
To: David Miller <davem@davemloft.net>
cc: romieu@fr.zoreil.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] drivers: net: usb: rtl8150: bug fixing and cleanup
In-Reply-To: <20130520.001252.838327096610376306.davem@davemloft.net>
Message-ID: <alpine.DEB.2.02.1305201014220.4719@fry.nucleusys.com>
References: <alpine.DEB.2.02.1305200941260.4719@fry.nucleusys.com> <20130520.000046.631828458050532836.davem@davemloft.net> <alpine.DEB.2.02.1305201008190.4719@fry.nucleusys.com> <20130520.001252.838327096610376306.davem@davemloft.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 May 2013, David Miller wrote:

> From: Petko Manolov <petkan@nucleusys.com>
> Date: Mon, 20 May 2013 10:09:00 +0300 (EEST)
> 
> > What about the .c/.h split?
> 
> I have no strong opinion either way.

OK, so i'll prepare new patch series that coalesce my original patch #1 
and #2, and apply the Francois suggestion about using the generic 
netdev_alloc_skb_ip_align() in the interrupt path.

Which tree would you want me to diff against?
