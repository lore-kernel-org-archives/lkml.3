Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410AbaKYHFW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 02:05:22 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:55734 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368AbaKYHFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 02:05:19 -0500
Date: Mon, 24 Nov 2014 00:28:20 -0800
From: Darren Hart <dvhart@infradead.org>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Mattia Dongili <malattia@linux.it>, platform-driver-x86@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH 1/1] Sony-laptop: Deletion of an unnecessary check before
 the function call "pci_dev_put"
Message-ID: <20141124082820.GC97532@vmdeb7>
References: <530C5E18.1020800@users.sourceforge.net>
 <alpine.DEB.2.10.1402251014170.2080@hadrien>
 <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net>
 <54739D50.5060104@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54739D50.5060104@users.sourceforge.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 10:04:16PM +0100, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Mon, 24 Nov 2014 22:00:21 +0100
> 
> The pci_dev_put() function tests whether its argument is NULL
> and then returns immediately. Thus the test around the call
> is not needed.
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>

Thanks Markus, queued.

-- 
Darren Hart
Intel Open Source Technology Center
