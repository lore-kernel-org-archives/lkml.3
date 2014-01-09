Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861AbaAIPEI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 10:04:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50216 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbaAIPEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 10:04:00 -0500
Date: Thu, 9 Jan 2014 07:04:28 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: me@anmolsarma.in
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] Staging: rtl8187se: ieee80211: ieee80211_softmac.c:
 mark symbols as static
Message-ID: <20140109150428.GA20411@kroah.com>
References: <cover.1389263965.git.me@anmolsarma.in>
 <9036792bea27cf00f564bbcb72f19de6b450f4a3.1389263965.git.me@anmolsarma.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9036792bea27cf00f564bbcb72f19de6b450f4a3.1389263965.git.me@anmolsarma.in>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 04:41:07PM +0530, me@anmolsarma.in wrote:
> From: Anmol Sarma <me@anmolsarma.in>
> 
> Fixes the following sparse warnings:
> 50:14: warning: symbol 'ieee80211_MFIE_rate_len' was not declared. Should it be
> static?
> 68:6: warning: symbol 'ieee80211_MFIE_Brate' was not declared. Should it be
> static?

Please don't line-wrap error messages like this, it makes it quite
messy, don't you think?

