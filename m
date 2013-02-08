Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760241Ab3BHSux (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 13:50:53 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:35930 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371Ab3BHSuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 13:50:51 -0500
Date: Fri, 08 Feb 2013 13:50:48 -0500 (EST)
Message-Id: <20130208.135048.1997648407258535972.davem@davemloft.net>
To: syrine.tl@gmail.com
Cc: matt.fleming@intel.com, sage@inktank.com, isdn@linux-pingi.de,
        megaraidlinux@lsi.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] linux-3.8-rc6 Fix Missing Allocation Failure Checks
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAETb2JMQ05RGuBuaoD39Db1j9--sth-3u+JXG6jaZkTvQyVkPw@mail.gmail.com>
References: <CAETb2JMQ05RGuBuaoD39Db1j9--sth-3u+JXG6jaZkTvQyVkPw@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: syrine tlili <syrine.tl@gmail.com>
Date: Fri, 8 Feb 2013 15:35:52 +0100

> --- linux-3.8-rc6-vanilla/arch/x86/platform/efi/efi.c	2013-02-01
> 02:08:14.000000000 +0100

Your email client corrupted the patch by breaking up long lines
amongst other things.

Please read Documentation/email-clients.txt to learn how to fix
this properly.

Before posting this patch for yet another time, email the patch to
yourself, and do not post the patch until you can successfully apply
the patch you receive in that test email to yourself.

Thanks.
