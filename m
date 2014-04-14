Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081AbaDNWi3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 18:38:29 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:49365 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755819AbaDNWi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 18:38:26 -0400
Date: Tue, 15 Apr 2014 02:38:21 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hughd@google.com,
        xemul@parallels.com
Subject: Re: [patch 2/4] mm: Dont forget to set softdirty on file mapped fault
Message-ID: <20140414223821.GD23983@moon>
References: <20140324122838.490106581@openvz.org>
 <20140324125926.013008345@openvz.org>
 <20140414152758.a9a80782dbb94c74a27f683a@linux-foundation.org>
 <20140414223309.GC23983@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140414223309.GC23983@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 02:33:09AM +0400, Cyrill Gorcunov wrote:
> On Mon, Apr 14, 2014 at 03:27:58PM -0700, Andrew Morton wrote:
> > 
> > This will need to be redone for current kernels, please.  New patch, new
> > title, new changelog, retest.
> 
> Sure, will resend once done.

Andrew, sorry, I'm a bit confused, jost got notifications you've picked them
up into -mm tree, right? So what I should do now -- by "current kernels" you
mean latest Linus's git repo?
