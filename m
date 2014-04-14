Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965AbaDNWn5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 18:43:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52802 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754255AbaDNWnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 18:43:53 -0400
Date: Mon, 14 Apr 2014 15:43:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hughd@google.com,
        xemul@parallels.com
Subject: Re: [patch 2/4] mm: Dont forget to set softdirty on file mapped
 fault
Message-Id: <20140414154351.9f09c43002463407a2b5f8b7@linux-foundation.org>
In-Reply-To: <20140414223821.GD23983@moon>
References: <20140324122838.490106581@openvz.org>
	<20140324125926.013008345@openvz.org>
	<20140414152758.a9a80782dbb94c74a27f683a@linux-foundation.org>
	<20140414223309.GC23983@moon>
	<20140414223821.GD23983@moon>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Apr 2014 02:38:21 +0400 Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> On Tue, Apr 15, 2014 at 02:33:09AM +0400, Cyrill Gorcunov wrote:
> > On Mon, Apr 14, 2014 at 03:27:58PM -0700, Andrew Morton wrote:
> > > 
> > > This will need to be redone for current kernels, please.  New patch, new
> > > title, new changelog, retest.
> > 
> > Sure, will resend once done.
> 
> Andrew, sorry, I'm a bit confused, jost got notifications you've picked them
> up into -mm tree, right?

1, 3 and 4.

> So what I should do now -- by "current kernels" you
> mean latest Linus's git repo?

yup.
