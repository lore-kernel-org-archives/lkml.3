Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718Ab3EMFFt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 01:05:49 -0400
Received: from gate.crashing.org ([63.228.1.57]:46206 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013Ab3EMFFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 01:05:48 -0400
Message-ID: <1368421535.19924.19.camel@pasglop>
Subject: Re: linux-next stats (Was: Linux 3-10-rc1)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-next@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 13 May 2013 15:05:35 +1000
In-Reply-To: <20130513111805.391a4d4c605d5cbfc3e8ff4d@canb.auug.org.au>
References: <CA+55aFwfK661zATyUpjkXJo1av51nmMweYdPJE7Le7S2KS3xwg@mail.gmail.com>
	 <20130513111805.391a4d4c605d5cbfc3e8ff4d@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-05-13 at 11:18 +1000, Stephen Rothwell wrote:
>      47 powerpc

Oops ;-)

So most of that *was* in -next for at least a day or two afaik just not
before the merge window opened. The reason for that is that I was on
an extended vacation for 5 weeks and was playing catch up until fairly
late, almost all of these are either bug fixes or things that were
posted for a while, reviewed and just hadn't been picked up due to the
lack of a maintainer. (Michael was my backup but he was busy getting
married :-)

Cheers,
Ben.



