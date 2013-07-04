Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933480Ab3GDV3x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 17:29:53 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:50864 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756900Ab3GDV3w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 17:29:52 -0400
Date: Thu, 04 Jul 2013 14:29:51 -0700 (PDT)
Message-Id: <20130704.142951.1908678475285188106.davem@davemloft.net>
To: linus.luessing@web.de
Cc: netdev@vger.kernel.org, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, linux-kernel@vger.kernel.org
Subject: Re: 'rmmod -f ipv6': BUG: unable to handle kernel paging request
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130704210434.GA6381@Linus-Debian>
References: <20130704210434.GA6381@Linus-Debian>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Lüssing <linus.luessing@web.de>
Date: Thu, 4 Jul 2013 23:04:34 +0200

> When trying to perform a forceful unload of an ipv6 kernel module
> on a 3.10 kernel then I'm getting a kernel panic with the attached
> trace.
> 
> Is this supposed to happen due to the '-f' option or is this a bug
> in the ipv6 code?

The ipv6 module is not capable of being unloaded, sorry.

By using "-f" you are taking your own risk in the matter.
