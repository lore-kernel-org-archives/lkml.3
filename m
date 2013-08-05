Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab3HEIXj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 04:23:39 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:60081 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585Ab3HEIXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 04:23:38 -0400
Date: Mon, 5 Aug 2013 01:23:20 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        acme@infradead.org, Andi Kleen <ak@linux.intel.com>,
        Namhyung Kim <namhyung.kim@lge.com>, peterz@infradead.org
Subject: Re: [PATCH] RFC: perf, tools: Move gtk browser into separate perfgtk
 executable
Message-ID: <20130805082320.GA9562@infradead.org>
References: <1375669364-13838-1-git-send-email-andi@firstfloor.org>
 <20130805081641.GA24808@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130805081641.GA24808@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 05, 2013 at 10:16:41AM +0200, Ingo Molnar wrote:
> If you want fewer dependencies then build with 'make NO_GTK=1'.

Doesn't help the distros.  Installing perf and pulling all the graphics
libraries in is highly annoying, especially in size constrained VM or
Cloud images.  Having a separate binary or at least an ldopen()able
plugin that can go into a separate package is highly desirable.

