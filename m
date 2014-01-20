Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910AbaATVyB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 16:54:01 -0500
Received: from benson.vm.bytemark.co.uk ([212.110.190.137]:37894 "EHLO
	benson.vm.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbaATVyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 16:54:00 -0500
Message-ID: <1390254835.10695.84.camel@dagon.hellion.org.uk>
Subject: Re: [PATCH] ARM: orion: provide C-style interrupt handler for
 MULTI_IRQ_HANDLER
From: Ian Campbell <ijc@hellion.org.uk>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Date: Mon, 20 Jan 2014 21:53:55 +0000
In-Reply-To: <20140116184943.GK29184@titan.lakedaemon.net>
References: <1389775235.10695.51.camel@dagon.hellion.org.uk>
	 <1389859831-9883-1-git-send-email-sebastian.hesselbarth@gmail.com>
	 <20140116164833.GH29184@titan.lakedaemon.net>
	 <1389891087.6697.26.camel@kazak.uk.xensource.com>
	 <20140116165347.GI29184@titan.lakedaemon.net> <52D82802.6090104@gmail.com>
	 <20140116184943.GK29184@titan.lakedaemon.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.4.4-4+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-01-16 at 13:49 -0500, Jason Cooper wrote:
> > @Ian: Thanks for hunting this down, please keep bothering us with
> > bug reports :)
> 
> Yes, please!

No worries there -- it seem Debian has quite a few people who use
kirkwood based systems and will report bugs when they find them...

Thanks (again?) for the quick fix.

Ian.

