Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037Ab3IXPjl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 11:39:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40729 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753492Ab3IXPjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 11:39:39 -0400
Date: Tue, 24 Sep 2013 11:34:32 -0400
From: Andy Gospodarek <andy@greyhouse.net>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Indenbaum <baum@tehutinetworks.net>
Subject: Re: question tehuti.c
Message-ID: <20130924153432.GI9773@gospo.rdu.redhat.com>
References: <alpine.DEB.2.02.1309231752040.2242@hadrien>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1309231752040.2242@hadrien>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 05:54:00PM +0200, Julia Lawall wrote:
> The function bdx_setmulti in the file drivers/net/ethernet/tehuti/tehuti.c
> contains:
> 
>         u32 rxf_val =
>             GMAC_RX_FILTER_AM | GMAC_RX_FILTER_AB | GMAC_RX_FILTER_OSEN;
> 
> and then later:
> 
>        } else {
>                 DBG("only own mac %d\n", netdev_mc_count(ndev));
>                 rxf_val |= GMAC_RX_FILTER_AB;
>         }
> 
> The last assignment doesn't look very useful, because GMAC_RX_FILTER_ABis
> already included in rxf_val.  Was something else intended?

You are correct that the setting of GMAC_RX_FILTER_AB is a bit redundant
since it was set earlier in the function.

I have not worked on this driver in several years and if there is no
response from Alexander or someone else at Tehuti Networks then you may
not get an answer to your question. :-/

