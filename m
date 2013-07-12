Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933339Ab3GLQ2b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 12:28:31 -0400
Received: from www.sr71.net ([198.145.64.142]:46605 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932612Ab3GLQ2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 12:28:30 -0400
Message-ID: <51E02EA8.9090700@sr71.net>
Date: Fri, 12 Jul 2013 09:28:24 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: linux-kernel@vger.kernel.org, x86@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] x86: perf: fix incorrect use of do_div() in nmi warning
References: <20130708214404.B0B6EA66@viggo.jf.intel.com> <20130712120843.GA21708@gmail.com>
In-Reply-To: <20130712120843.GA21708@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2013 05:08 AM, Ingo Molnar wrote:
>> > Note, there was a second fix posted by Stephane Eranian for
>> > a separate patch which I also botched:
>> > 
>> > 	http://lkml.kernel.org/r/20130704223010.GA30625@quad
>> > 
>> > Both of these fixes need to get pulled in to Linus's tree and
>> > the 3.10 stable tree.
> This is a brand new v3.11 commit.
> 
> It should not be included in any -stable tree, is it?

Ingo, you are correct.  The commit only appeared in Linus's tree
post-3.10.  It does not need to be in any stable trees.
