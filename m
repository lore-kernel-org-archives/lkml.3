Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933311AbaHYTDf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 15:03:35 -0400
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:33267 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbaHYTDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 15:03:34 -0400
Date: Mon, 25 Aug 2014 20:02:15 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Fejes =?UTF-8?B?SsOzenNlZg==?= <jozsef.fejes@gmail.com>,
        linux-kernel@vger.kernel.org, linux-stable@vger.kernel.org,
        "David E. Box" <david.e.box@linux.intel.com>
Subject: Re: Problem with commit: x86, iosf: Make IOSF driver modular and
 usable by more drivers
Message-ID: <20140825200215.6c0e900f@alan.etchedpixels.co.uk>
In-Reply-To: <53F8D1FE.5050205@infradead.org>
References: <CALU-w9-ZjjnrYW5HxRCe-HGZWSK0JMwNU_zcSbKXM4JgGyLdbw@mail.gmail.com>
	<53F8D1FE.5050205@infradead.org>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> David, any other suggestions?
> Why can't the users of IOSF_MBI just select it?  That's what many other
> drivers do when they need to be sure that some functionality is present.

I think the obvious problem is that most users of IOSF_MBI are
non-obvious and there will be many of them over time.
> 
> I'm surprised that someone else (e.g. Linus) has not complained about the
> 'default m' for this driver.

That's certainly wrong, but drivers that use it should probably
auto-select it or we will get a billion bug reports asking why graphics
doesn't work etc 

Alan
