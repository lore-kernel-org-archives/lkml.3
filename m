Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008AbaETRCt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 13:02:49 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:25394 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752128AbaETRCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 13:02:48 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ai4WANuJe1NbsnsG/2dsb2JhbABZgwaCRKhIAQEBAQEBBQGDOpZuAgIBgRsXdIIlAQEEATo/BQsIAxguOR4GExSIJQwB1BMXhVWIeQeEQAEDmWcBkyCDOjs
Date: Tue, 20 May 2014 19:02:46 +0200
From: Fabian Frederick <fabf@skynet.be>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>
Subject: Re: [PATCH V3 mmots] fs/hfsplus/wrapper.c: replace shift loop by
 ilog2
Message-Id: <20140520190246.cb6de4afd7946e2ce8b9f595@skynet.be>
In-Reply-To: <1400604934.19170.6.camel@buesod1.americas.hpqcorp.net>
References: <20140520184334.9e903b4965a5776eb0e771e2@skynet.be>
	<1400604934.19170.6.camel@buesod1.americas.hpqcorp.net>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2014 09:55:34 -0700
Davidlohr Bueso <davidlohr@hp.com> wrote:

> On Tue, 2014-05-20 at 18:43 +0200, Fabian Frederick wrote:
> > Replace while blocksize;shift by ilog2
> 
> Fabian, please start getting into the habit of improving your
> changelogs. Unlike a lot of OSS projects, the kernel community (usually)
> takes pride in having good ones. You send a number of patches but rarely
> explain a key concept of software development in general: *WHY* do we
> need this.
> 
> Thanks,
> Davidlohr
> 

Hello Davidlohr,

	You're absolutely right, I'll do my best to improve that in the future.

Regards,	
Fabian
