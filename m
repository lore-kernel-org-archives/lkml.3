Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938AbaE0KFl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 06:05:41 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:60475 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbaE0KFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 06:05:38 -0400
Message-ID: <1401185133.5134.119.camel@marge.simpson.net>
Subject: Re: balance storm
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Libo Chen <libo.chen@huawei.com>, tglx@linutronix.de, mingo@elte.hu,
        LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, Li Zefan <lizefan@huawei.com>
Date: Tue, 27 May 2014 12:05:33 +0200
In-Reply-To: <20140527094802.GN30445@twins.programming.kicks-ass.net>
References: <5382AF2E.1040407@huawei.com>
	 <1401090987.5339.79.camel@marge.simpson.net> <53832A36.5020205@huawei.com>
	 <20140527094802.GN30445@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-05-27 at 11:48 +0200, Peter Zijlstra wrote:

> So I suppose this is due to the select_idle_sibling() nonsense again,
> where we assumes L3 is a fair compromise between cheap enough and
> effective enough.

Nodz.

> Of course, Intel keeps growing the cpu count covered by L3 to ridiculous
> sizes, 8 cores isn't nowhere near their top silly, which shifts the
> balance, and there's always going to be pathological cases (like the
> proposed workload) where its just always going to suck eggs.

Test is as pathological as it gets.  15 core + SMT wouldn't be pretty.

-Mike

