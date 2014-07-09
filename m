Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932347AbaGIWU0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 18:20:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1749 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932139AbaGIWUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 18:20:22 -0400
Date: Thu, 10 Jul 2014 00:19:58 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, namhyung@kernel.org, acme@infradead.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 3/9] perf, tools: Add support for reading JSON event
 files v3
Message-ID: <20140709221958.GH20938@krava.redhat.com>
References: <1403910964-11017-1-git-send-email-andi@firstfloor.org>
 <1403910964-11017-4-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403910964-11017-4-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Im confused, your branch shows v4 in patch Subject,
while this patch has v3... ?

jirka

On Fri, Jun 27, 2014 at 04:15:58PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Add a parser for Intel style JSON event files. This allows
> to use an Intel event list directly with perf. The Intel
> event lists can be quite large and are too big to store
> in unswappable kernel memory.
> 
> The parser code knows how to convert the JSON fields
> to perf fields. The conversion code is straight forward.
> It knows (very little) Intel specific information, and can be easily
> extended to handle fields for other CPUs.
> 
> The parser code is partially shared with an independent parsing
> library, which is 2-clause BSD licenced. To avoid any conflicts I marked
> those files as BSD licenced too. As part of perf they become GPLv2.
> 

SNIP

