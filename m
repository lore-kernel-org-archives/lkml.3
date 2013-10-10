Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811Ab3JJETm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 00:19:42 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:56174 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381Ab3JJETl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 00:19:41 -0400
Date: Thu, 10 Oct 2013 00:19:39 -0400 (EDT)
Message-Id: <20131010.001939.1669180620160012783.davem@davemloft.net>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, mingo@kernel.org, peterz@infradead.org,
        hpa@linux.intel.com, williams@redhat.com, bp@alien8.de,
        akpm@linux-foundation.org
Subject: Re: [RFC][PATCH] x86: Lazy disabling of interrupts
From: David Miller <davem@davemloft.net>
In-Reply-To: <20131010001153.1f171bff@gandalf.local.home>
References: <20131009144150.108f7041@gandalf.local.home>
	<20131010001153.1f171bff@gandalf.local.home>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 09 Oct 2013 21:19:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>
Date: Thu, 10 Oct 2013 00:11:53 -0400

> 
> I'm replying to my email to see if that helps make it to LKML. If it
> doesn't, I'm sorry for the noise to all I Cc'd.

The problem is the:

H.PeterAnvin

in the CC list, you can't have a name with the "." charater it appear in
email headers unless the string is surrounded by double quotes.  Otherwise
it's a syntax error.

