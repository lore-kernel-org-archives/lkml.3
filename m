Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563Ab3ETRJw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 13:09:52 -0400
Received: from sauhun.de ([89.238.76.85]:57868 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934Ab3ETRJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 13:09:50 -0400
Date: Mon, 20 May 2013 19:11:22 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH 30/33] arch/arm/plat-samsung: don't check resource with
 devm_ioremap_resource
Message-ID: <20130520171118.GA5717@katana>
References: <1368702961-4325-1-git-send-email-wsa@the-dreams.de>
 <1368702961-4325-31-git-send-email-wsa@the-dreams.de>
 <519A517F.5020003@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <519A517F.5020003@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 21, 2013 at 01:38:23AM +0900, Kukjin Kim wrote:
> On 05/16/13 20:15, Wolfram Sang wrote:
> >devm_ioremap_resource does sanity checks on the given resource. No need to
> >duplicate this in the driver.
> >
> >Signed-off-by: Wolfram Sang<wsa@the-dreams.de>
> 
> Looks good to me, applied into Samsung tree.
> 
> Wolfram, if you want to take this into your tree, let me know.

It is already upstream :)

