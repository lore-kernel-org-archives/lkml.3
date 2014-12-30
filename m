Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647AbaL3MSt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 07:18:49 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:39914 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbaL3MSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 07:18:48 -0500
Date: Tue, 30 Dec 2014 04:18:37 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Charles Chiou <ch1102chiou@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, JBottomley@parallels.com,
        Oliver Neukum <oneukum@suse.de>, ed.lin@promise.com,
        grace.chang@tw.promise.com, linus.chen@tw.promise.com,
        victor.p@promise.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4 v3] scsi:stex.c Add reboot support
Message-ID: <20141230121837.GG32187@infradead.org>
References: <548FCD81.7030106@gmail.com>
 <20141217093027.GA13198@infradead.org>
 <54924CEA.3060808@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54924CEA.3060808@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2014 at 11:41:30AM +0800, Charles Chiou wrote:
> Sorry, I'm not understand what is meaning of "series".
> Could you specify what you what me to send you?

Series means a set of patches, e.g. all the ones you send.

Talking about patches series it would be very helpful if you send the
actual patches as replies to the [PATCH 0/n] introduction mail.  The
git-send-email tool is a great way to do this automatically.
