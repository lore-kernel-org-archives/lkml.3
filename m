Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622AbaF2I2e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 04:28:34 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:6447 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752467AbaF2I2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 04:28:32 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AloSAPXMr1NbsmJR/2dsb2JhbABZgw1SgXeBAKhxBQFuAZlCAgIBgQYXdYQDAQEEATocGAsQCANGOR4GE4g6DAEIxXsXhWSIP2QHhEMBBJpdAYFGkjeCAIFEOy+BAg
Date: Sun, 29 Jun 2014 10:27:14 +0200
From: Fabian Frederick <fabf@skynet.be>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-kernel@vger.kernel.org, Coccinelle <cocci@systeme.lip6.fr>,
        Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH V3] scripts/coccinelle/free: Delete NULL test before
 freeing functions?
Message-Id: <20140629102714.ea430bbd1f7c19e2f18fa56f@skynet.be>
In-Reply-To: <53AF2CE6.5020300@users.sourceforge.net>
References: <1403945247-21549-1-git-send-email-fabf@skynet.be>
	<53AE8613.8080600@users.sourceforge.net>
	<20140628120052.0b8670723928a967808dd544@skynet.be>
	<53AEA927.3010100@users.sourceforge.net>
	<20140628140157.98304218ad0919b1567cfee4@skynet.be>
	<53AF2CE6.5020300@users.sourceforge.net>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Jun 2014 23:00:22 +0200
SF Markus Elfring <elfring@users.sourceforge.net> wrote:

> > Sorry but I'm not working on coccinelle ; just did a small script for kernel tree.
> 
> I would appreciate a more constructive feedback for my update suggestions around
> the topic "Deletion of unnecessary checks before specific function calls".
> - Did you look at the concrete patches?
> - How do you think about the general approach?
> 
> Examples:
> https://systeme.lip6.fr/pipermail/cocci/2014-March/000676.html
> http://marc.info/?l=kernel-janitors&m=139405971927100&w=2
> 
> https://systeme.lip6.fr/pipermail/cocci/2014-March/000677.html
> http://marc.info/?l=kernel-janitors&m=139405983727148&w=2
> 
> Regards,
> Markus

Hello Markus,

	I hope you had information you wanted from Julia ?
If you want more feedback, maybe you can create a new RFC (Request For Comment) in Linux Kernel mailing.

Regards,
Fabian

