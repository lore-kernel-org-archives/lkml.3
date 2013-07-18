Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757764Ab3GRABx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 20:01:53 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:36471 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754572Ab3GRABw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 20:01:52 -0400
Message-ID: <1374105711.1949.116.camel@joe-AO722>
Subject: Re: [v3.11-rc1 PATCH 0/5] printk: Initial restructuring
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed, 17 Jul 2013 17:01:51 -0700
In-Reply-To: <20130717153124.29de2c562b3f4bdb3d1f464b@linux-foundation.org>
References: <cover.1373922863.git.joe@perches.com>
	 <CA+55aFwJh5yFeOmPrR=3VqY1StmqTn0sRzwtkCA5N8b=-==otQ@mail.gmail.com>
	 <1374026199.1949.62.camel@joe-AO722>
	 <20130717153124.29de2c562b3f4bdb3d1f464b@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-17 at 15:31 -0700, Andrew Morton wrote:
> On Tue, 16 Jul 2013 18:56:39 -0700 Joe Perches <joe@perches.com> wrote:
> > There were a few 9 months ago.
> > 
> > Mostly it was a timing issue as to who
> > takes it and when.
> 
> Well it also broke the build a bit, iirc.

V1 did with a !CONFIG_PRINTK, v2 fixed that.

> I grabbed them and will give them a run in -next for a week or so.  If
> that's OK then I'll try to offload everything onto Linus rather than
> having to spend two months battling with linux-next monkeyscratchings.

Yup, that's the problem...

