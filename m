Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbaGKWzc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 18:55:32 -0400
Received: from one.firstfloor.org ([193.170.194.197]:50297 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbaGKWzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 18:55:31 -0400
Date: Sat, 12 Jul 2014 00:55:29 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        namhyung@kernel.org, acme@infradead.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/9] perf, tools: Add support for text descriptions of
 events and alias add
Message-ID: <20140711225529.GV18735@two.firstfloor.org>
References: <1403910964-11017-1-git-send-email-andi@firstfloor.org>
 <1403910964-11017-3-git-send-email-andi@firstfloor.org>
 <20140709221923.GE20938@krava.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140709221923.GE20938@krava.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> so this ^^^ gets removed by
>   perf, tools: Query terminal width and use in perf list
> 
> please move that patch ahead of this one

This cannot be done. There is no code to consume the column width
before the other patch.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
