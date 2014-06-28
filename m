Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766AbaF1MDR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 08:03:17 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:65038 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751710AbaF1MDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 08:03:16 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnoPABKurlNbsk2v/2dsb2JhbABZgw1SgXeBAKg2AQEBAQEBBQFtAZh4BgICAYEGF3WEAwEBBAE6HCMFCwgDRjkeBhOIOgwBCMURF4VkhxiBJWQHhEMBBJpcAYFGkjWCAIFEOy8BAYEA
Date: Sat, 28 Jun 2014 14:01:57 +0200
From: Fabian Frederick <fabf@skynet.be>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-kernel@vger.kernel.org, Coccinelle <cocci@systeme.lip6.fr>,
        Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH V3] scripts/coccinelle/free: Delete NULL test before
 freeing functions?
Message-Id: <20140628140157.98304218ad0919b1567cfee4@skynet.be>
In-Reply-To: <53AEA927.3010100@users.sourceforge.net>
References: <1403945247-21549-1-git-send-email-fabf@skynet.be>
	<53AE8613.8080600@users.sourceforge.net>
	<20140628120052.0b8670723928a967808dd544@skynet.be>
	<53AEA927.3010100@users.sourceforge.net>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Jun 2014 13:38:15 +0200
SF Markus Elfring <elfring@users.sourceforge.net> wrote:

> 
> >> How do you think about my previous update suggestion "Deletion of
> >> unnecessary checks before specific function calls"?
> >> https://systeme.lip6.fr/pipermail/cocci/2014-March/000675.html
> >> https://lkml.org/lkml/2014/3/5/344
> >     I didn't see you made the same kind of script.
> 
> Will my approach become a bit more complete in the near future?
> http://article.gmane.org/gmane.comp.version-control.coccinelle/3512/
> 

Sorry but I'm not working on coccinelle ; just did a small script for kernel tree. I guess you'll have an answer from coccinelle people.

Regards,
Fabian

> Regards,
> Markus
