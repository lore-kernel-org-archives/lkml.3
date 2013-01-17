Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050Ab3AQKud (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 05:50:33 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:63722 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037Ab3AQKuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 05:50:23 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Soeren Moch <smoch@web.de>
Subject: Re: [PATCH v2] mm: dmapool: use provided gfp flags for all dma_alloc_coherent() calls
Date: Thu, 17 Jan 2013 10:49:30 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: Jason Cooper <jason@lakedaemon.net>, Greg KH <gregkh@linuxfoundation.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, Kyungmin Park <kyungmin.park@samsung.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linaro-mm-sig@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
References: <20121119144826.f59667b2.akpm@linux-foundation.org> <20130116024014.GH25500@titan.lakedaemon.net> <50F61D86.4020801@web.de>
In-Reply-To: <50F61D86.4020801@web.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301171049.30415.arnd@arndb.de>
X-Provags-ID: V02:K0:VQ8zYUZXF5RKjdlEC5+6M441FcIwh6fUuLSbcm12A2w
 hEkLLcPWBWqqrI3qQc12FMJIMZ95yEBnM23IpA1oU5EWUBY5Oz
 7U1CrzAvN6u2My1A//2snod7CV4L1dwf9x29Kfojx1zr/eUBNr
 7LfrWIE3ScvyuO40uF1Jlh6vwTOIdwIAhVxkS6yaMSzS3BvDE+
 1vqaAOcxTuHUm3Si7OoBlgc62IJ76bStz1rd4Pgt8V9MBpNEn6
 MNNyiz93iMDLO7kUFsvmRvBDoJtZyIFElVNIHTXCMsYxU+DP6M
 J7SitH90mq6ubaS8mwX0f4BtPmSia416zROd/4V3Dd19pSY0h6
 AbVb8OOq3kIXv88BZank=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 January 2013, Soeren Moch wrote:
> >> I will see what I can do here. Is there an easy way to track the buffer
> >> usage without having to wait for complete exhaustion?
> >
> > DMA_API_DEBUG
> 
> OK, maybe I can try this.
> >

Any success with this? It should at least tell you if there is a
memory leak in one of the drivers.

	Arnd
