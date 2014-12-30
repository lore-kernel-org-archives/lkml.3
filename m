Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655AbaL3MUG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 07:20:06 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:40516 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994AbaL3MUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 07:20:03 -0500
Date: Tue, 30 Dec 2014 04:19:57 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Charles Chiou <ch1102chiou@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, JBottomley@parallels.com,
        Oliver Neukum <oneukum@suse.de>, ed.lin@promise.com,
        grace.chang@tw.promise.com, linus.chen@tw.promise.com,
        victor.p@promise.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4 v3] scsi:stex.c Add reboot support
Message-ID: <20141230121957.GH32187@infradead.org>
References: <548FCD81.7030106@gmail.com>
 <20141217093027.GA13198@infradead.org>
 <54924CEA.3060808@gmail.com>
 <5498DA51.7030207@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5498DA51.7030207@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 23, 2014 at 10:58:25AM +0800, Charles Chiou wrote:
> Hi, after our internal discussion, we can use shutdown flow for reboot
> temporarily. Some signal issue will happen (depend on MB), and it can be
> fixed by plug in and plug out manually. We will add reboot feature after PM
> can pass reboot information to ->shutdown.

Thanks.  Please send the updated patch series to the list.

Note that you should also try to pass the information you need through
proper channels, e.g. adding an argument to the ->shutdown method.
Please send this to the linux-pm ad linux-kernel lists.
