Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571AbaAIPPk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 10:15:40 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:35995 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbaAIPPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 10:15:33 -0500
Date: Thu, 9 Jan 2014 18:15:18 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: me@anmolsarma.in
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] Staging: rtl8187se: ieee80211: ieee80211_softmac.c:
 mark symbols as static
Message-ID: <20140109151518.GS30234@mwanda>
References: <cover.1389263965.git.me@anmolsarma.in>
 <9036792bea27cf00f564bbcb72f19de6b450f4a3.1389263965.git.me@anmolsarma.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9036792bea27cf00f564bbcb72f19de6b450f4a3.1389263965.git.me@anmolsarma.in>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 04:41:07PM +0530, me@anmolsarma.in wrote:
> From: Anmol Sarma <me@anmolsarma.in>


Fix your email so this is in the email headers themselves.

> 
> Fixes the following sparse warnings:
> 50:14: warning: symbol 'ieee80211_MFIE_rate_len' was not declared. Should it be
> static?
> 68:6: warning: symbol 'ieee80211_MFIE_Brate' was not declared. Should it be
> static?

We don't need so many of these warnings just one or two is enough, we
get the idea.

regards,
dan carpenter


