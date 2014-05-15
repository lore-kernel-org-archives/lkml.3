Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520AbaEOUSl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 16:18:41 -0400
Received: from one.firstfloor.org ([193.170.194.197]:36281 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755267AbaEOUSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 16:18:40 -0400
Date: Thu, 15 May 2014 22:18:38 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, acme@infradead.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org, eranian@google.com,
        jolsa@redhat.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 3/9] perf, tools: Add support for reading JSON event
 files
Message-ID: <20140515201838.GE1873@two.firstfloor.org>
References: <1399935074-25167-1-git-send-email-andi@firstfloor.org>
 <1399935074-25167-4-git-send-email-andi@firstfloor.org>
 <874n0tlzcl.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874n0tlzcl.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> And more generally, can we extend these if-else's to a generic loop to
> check a table like in match_field() so that it can be added easily?

The simple cases are all already handled in a table above.

The if() only contains cases that need special code. I don't think
callbacks would be better here.

-Andi
