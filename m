Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759870Ab3CGVti (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 16:49:38 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:46599 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827Ab3CGVth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 16:49:37 -0500
Date: Thu, 07 Mar 2013 16:49:35 -0500 (EST)
Message-Id: <20130307.164935.1743147312624311513.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: davej@redhat.com, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: ipc/testmsg GPF.
From: David Miller <davem@davemloft.net>
In-Reply-To: <CA+55aFx424SX6S1zFegVaMZ_BkeZctDKCN6eYCLFfaJDKRVG9g@mail.gmail.com>
References: <CA+55aFwDYocNRjSCJk1PYw0MFy7dpKf1yMMEiePP--=ewQcX6A@mail.gmail.com>
	<20130307213819.GB19543@redhat.com>
	<CA+55aFx424SX6S1zFegVaMZ_BkeZctDKCN6eYCLFfaJDKRVG9g@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Thu, 07 Mar 2013 13:49:41 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 7 Mar 2013 13:45:27 -0800

> Adding Davem to the list, since this looks like networking.

I'd like to help but this looks more like sysv IPC than
networking. :-)
