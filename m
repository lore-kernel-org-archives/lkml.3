Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933782AbaKMTUe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 14:20:34 -0500
Received: from mail.kernel.org ([198.145.19.201]:55485 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932939AbaKMTUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 14:20:33 -0500
Date: Thu, 13 Nov 2014 16:20:28 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: jolsa@redhat.com, linux-kernel@vger.kernel.org, namhyung@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 06/10] perf, tools: Enable printing the srcline in the
 history
Message-ID: <20141113192028.GG3612@kernel.org>
References: <1415844328-4884-1-git-send-email-andi@firstfloor.org>
 <1415844328-4884-7-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415844328-4884-7-git-send-email-andi@firstfloor.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Nov 12, 2014 at 06:05:24PM -0800, Andi Kleen escreveu:
> From: Andi Kleen <ak@linux.intel.com>
> 
> For lbr-as-callgraph we need to see the line number in the history,
> because many LBR entries can be in a single function, and just
> showing the same function name many times is not useful.
> 
> When the history code is configured to sort by address, also try to
> resolve the address to a file:srcline and display this in the browser.
> If that doesn't work still display the address.
> 
> This can be also useful without LBRs for understanding which call in a large
> function (or in which inlined function) called something else.
> 
> Contains fixes from Namhyung Kim

Applied.

- Arnaldo
