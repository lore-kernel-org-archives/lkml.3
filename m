Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751384AbaLCAsz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 19:48:55 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:39987 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750750AbaLCAsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 19:48:54 -0500
X-Sasl-enc: BYzbClvoSvbdoVSP94oTL9FtLxB1o2b6zrRl+GqRuj2/ 1417567733
Date: Tue, 2 Dec 2014 16:48:52 -0800
From: Greg KH <greg@kroah.com>
To: Paul Hedman <paul@mybboard.net>
Cc: paul@mybb.com, marek.belisko@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: ft1000: fix spaces around comparisons in
 ft1000_debug.c
Message-ID: <20141203004852.GA15236@kroah.com>
References: <1417533075-687-1-git-send-email-paul@mybb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417533075-687-1-git-send-email-paul@mybb.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2014 at 09:11:15AM -0600, Paul Hedman wrote:
> This fix fixes spacing issues around operators, e.g. i=0 to i = 0, found by the checkpatch.pl tool.

Please wrap your changelog at the correct column.

> 
> Signed-off-by: Paul Hedman <paul@mybb.com>
> ---
>  drivers/staging/ft1000/ft1000-usb/ft1000_debug.c | 28 ++++++++++++------------
>  1 file changed, 14 insertions(+), 14 deletions(-)

This doesn't apply to my tree at all :(

