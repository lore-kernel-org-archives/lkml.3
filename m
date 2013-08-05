Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322Ab3HEIbk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 04:31:40 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:62723 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754850Ab3HEIbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 04:31:36 -0400
Date: Mon, 5 Aug 2013 10:31:32 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        acme@infradead.org, Andi Kleen <ak@linux.intel.com>,
        Namhyung Kim <namhyung.kim@lge.com>, peterz@infradead.org
Subject: Re: [PATCH] RFC: perf, tools: Move gtk browser into separate perfgtk
 executable
Message-ID: <20130805083132.GE26746@gmail.com>
References: <1375669364-13838-1-git-send-email-andi@firstfloor.org>
 <20130805081641.GA24808@gmail.com>
 <20130805082320.GA9562@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130805082320.GA9562@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Hellwig <hch@infradead.org> wrote:

> On Mon, Aug 05, 2013 at 10:16:41AM +0200, Ingo Molnar wrote:
>
> > If you want fewer dependencies then build with 'make NO_GTK=1'.
> 
> Doesn't help the distros.  Installing perf and pulling all the graphics 
> libraries in is highly annoying, especially in size constrained VM or 
> Cloud images.  Having a separate binary or at least an ldopen()able 
> plugin that can go into a separate package is highly desirable.

Nonsense, a distro, if it truly worried about this, could create two 
packages already, there's no need to expose configuration options in the 
binary name itself and burden users with the separation. I sometimes 
switch the UI frontend of perf depending on the workflow and the terminal, 
it would be highly annoying if the binary name was changed to expose 
configuration options.

The thing is, you strongly objected to perf itself when we offered it up 
for an upstream merge and I'm not surprised you still don't like it.

Thanks,

	Ingo
