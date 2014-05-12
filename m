Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758472AbaELOmk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 10:42:40 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58379 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbaELOmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 10:42:37 -0400
Date: Mon, 12 May 2014 10:42:36 -0400 (EDT)
Message-Id: <20140512.104236.532684219767927312.davem@davemloft.net>
To: w@1wt.eu
Cc: minipli@googlemail.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, linux-kernel.bfrz@manchmal.in-ulm.de
Subject: Re: [ 030/143] proc connector: fix info leaks
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140512085704.GA18258@1wt.eu>
References: <20140512003201.879931356@1wt.eu>
	<CA+rthh91-GB=PPMckeDHEco=vLOimB7fBt0nVX_C+gDz3BRngg@mail.gmail.com>
	<20140512085704.GA18258@1wt.eu>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 12 May 2014 07:42:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Willy Tarreau <w@1wt.eu>
Date: Mon, 12 May 2014 10:57:04 +0200

> Thank you guys, I'll check. I don't know why I didn't see them on an
> allmodconfig build.

Because you have to enable connector as "y", rather than "m", for the
proc connector to be available in the config.
