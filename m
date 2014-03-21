Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760789AbaCUOlr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 10:41:47 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:58611 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759957AbaCUOlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 10:41:45 -0400
Message-ID: <1395412904.6030.126.camel@marge.simpson.net>
Subject: RE: Bug 71331 - mlock yields processor to lower priority process
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: jimmie.davis@l-3com.com
Cc: oneukum@suse.de, artem_fetishev@epam.com, peterz@infradead.org,
        kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org
Date: Fri, 21 Mar 2014 15:41:44 +0100
In-Reply-To: <FFF95760268D324AB6DD9426E83C8DF70B2E58FB@ARLEXCHMBX01.lst.link.l-3com.com>
References: <20140321200248.GB6264@owamsq.epam.com>
	 ,<1395393822.6030.59.camel@marge.simpson.net>
	 <FFF95760268D324AB6DD9426E83C8DF70B2E5870@ARLEXCHMBX01.lst.link.l-3com.com>
	 ,<1395408925.9455.3.camel@linux-fkkt.site>
	 <FFF95760268D324AB6DD9426E83C8DF70B2E58FB@ARLEXCHMBX01.lst.link.l-3com.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-03-21 at 14:01 +0000, jimmie.davis@l-3com.com wrote:

> If you call mlock () from a SCHED_FIFO task, you expect it to return
> when done.  You don't expect it to block, and your task to be
> pre-empted.

Say some of your pages are sitting in an nfs swapfile orbiting Neptune,
how do they get home, and what should we do meanwhile?

-Mike
> 
> 
> 
> 
> 


