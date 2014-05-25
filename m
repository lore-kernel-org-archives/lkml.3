Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751473AbaEYDSh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 23:18:37 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:48103 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751262AbaEYDSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 23:18:36 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhMgAMdfgVNXQDTn/2dsb2JhbABZgweCRX6nUgEBAQEBAQUBgzyUSAICAQEBgQMXdIIlAQEEATocIwULCAMYHRE5HgYTiDoMAddMF4VViH0HhEABA5lyAYsXiBCDOjs
Date: Sun, 25 May 2014 05:18:36 +0200
From: Fabian Frederick <fabf@skynet.be>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/4] lib/debugobjects.c: convert printk to pr_foo()
Message-Id: <20140525051836.116fe09126f16de8b3955d27@skynet.be>
In-Reply-To: <20140524215322.GA24038@thin>
References: <1400936768-24897-1-git-send-email-fabf@skynet.be>
	<20140524215322.GA24038@thin>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 May 2014 14:53:22 -0700
Josh Triplett <josh@joshtriplett.org> wrote:

> On Sat, May 24, 2014 at 03:06:08PM +0200, Fabian Frederick wrote:
> > Convert all except KERN_DEBUG
> 
> Why not KERN_DEBUG?
printk(KERN_DEBUG can't be converted to pr_debug the same way as other printk.
