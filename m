Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031AbaF1KCL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 06:02:11 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:42858 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750754AbaF1KCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 06:02:10 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnwPAPGRrlNbsk2v/2dsb2JhbABagw1SgXeBAKg2AQEBAQEBBQFtAZh4AQUCAgGBBxd1hAMBAQQBOhwjEAgDRjkeBhOIOgwBCMUJEwSFZIcYgSVkB4RDAQSaXAGTe4IAgUQ7L4EC
Date: Sat, 28 Jun 2014 12:00:52 +0200
From: Fabian Frederick <fabf@skynet.be>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-kernel@vger.kernel.org, Coccinelle <cocci@systeme.lip6.fr>,
        Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH V3] scripts/coccinelle/free: Delete NULL test before
 freeing functions?
Message-Id: <20140628120052.0b8670723928a967808dd544@skynet.be>
In-Reply-To: <53AE8613.8080600@users.sourceforge.net>
References: <1403945247-21549-1-git-send-email-fabf@skynet.be>
	<53AE8613.8080600@users.sourceforge.net>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Jun 2014 11:08:35 +0200
SF Markus Elfring <elfring@users.sourceforge.net> wrote:

> 
> > V3: 
> >    -Update print_main message.
> 
> Does the discussion topic need also an adjustment?
> 
> How do you think about my previous update suggestion "Deletion of
> unnecessary checks before specific function calls"?
> https://systeme.lip6.fr/pipermail/cocci/2014-March/000675.html
> https://lkml.org/lkml/2014/3/5/344

Hello Markus,

    I didn't see you made the same kind of script.
Ok, you can send yours and we forget this one :)

Regards,
Fabian


> 
> Regards,
> Markus
