Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224Ab3HEIeo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 04:34:44 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:60135 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754656Ab3HEIen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 04:34:43 -0400
Date: Mon, 5 Aug 2013 01:34:34 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, acme@infradead.org,
        Andi Kleen <ak@linux.intel.com>, Namhyung Kim <namhyung.kim@lge.com>,
        peterz@infradead.org
Subject: Re: [PATCH] RFC: perf, tools: Move gtk browser into separate perfgtk
 executable
Message-ID: <20130805083434.GA20606@infradead.org>
References: <1375669364-13838-1-git-send-email-andi@firstfloor.org>
 <20130805081641.GA24808@gmail.com>
 <20130805082320.GA9562@infradead.org>
 <20130805083132.GE26746@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130805083132.GE26746@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 05, 2013 at 10:31:32AM +0200, Ingo Molnar wrote:
> Nonsense, a distro, if it truly worried about this, could create two 
> packages already, there's no need to expose configuration options in the 
> binary name itself and burden users with the separation. I sometimes 
> switch the UI frontend of perf depending on the workflow and the terminal, 
> it would be highly annoying if the binary name was changed to expose 
> configuration options.

Which means you'd have to use a different tool name or have incompatible
packages, both of which aren't desirable.

> The thing is, you strongly objected to perf itself when we offered it up 
> for an upstream merge and I'm not surprised you still don't like it.

I strongly objected to adding it to the kernel tree, and I still stand
to that opinion because it makes using perf much more painful than it
needs to be.  I never disliked perf itself and use it frequently now
that I can bypass some of the pains by just using an older distro
package.

But I'd much rather get this back to technical discussions than personal
attacks..

