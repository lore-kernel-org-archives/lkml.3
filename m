Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965010AbaFRGTK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 02:19:10 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:59168 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934033AbaFRGTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 02:19:08 -0400
Date: Tue, 17 Jun 2014 23:19:04 -0700 (PDT)
Message-Id: <20140617.231904.4918050259821316.davem@davemloft.net>
To: sam@ravnborg.org
Cc: peter@hurleysoftware.com, aaro.koskinen@iki.fi,
        linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
        gregkh@linuxfoundation.org, sethb@digi.com,
        LinusTorvaldstorvalds@linux-foundation.org
Subject: Re: Linux 3.15: SPARC serial console regression
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140615185635.GA22577@ravnborg.org>
References: <20140610192438.GA6846@ravnborg.org>
	<53977688.5080802@hurleysoftware.com>
	<20140615185635.GA22577@ravnborg.org>
X-Mailer: Mew version 6.3 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 17 Jun 2014 23:19:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Ravnborg <sam@ravnborg.org>
Date: Sun, 15 Jun 2014 20:56:35 +0200

> This is a regression so we should either revert the above commit
> or review and fix the remaining drivers.

I plan to review and integrate the sparc serial driver fixes
soon.
