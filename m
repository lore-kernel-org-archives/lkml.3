Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120AbaFVCWY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 22:22:24 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:41035 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbaFVCWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 22:22:22 -0400
Date: Sat, 21 Jun 2014 19:22:18 -0700 (PDT)
Message-Id: <20140621.192218.1801115154664681697.davem@davemloft.net>
To: grantgrundler@gmail.com
Cc: linux@rainbow-software.org, grundler@parisc-linux.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tulip: Poll link status more frequently for Comet chips
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAP6odjjE3hYXPggagPvF+hYm7nGHQqLqeQ3Ls9jzd=DVBLcJ4w@mail.gmail.com>
References: <1403382541-7129-1-git-send-email-linux@rainbow-software.org>
	<CAP6odjjE3hYXPggagPvF+hYm7nGHQqLqeQ3Ls9jzd=DVBLcJ4w@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sat, 21 Jun 2014 19:22:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Grundler <grantgrundler@gmail.com>
Date: Sat, 21 Jun 2014 15:59:30 -0700

> Hi Ondrej,
> 
> On Sat, Jun 21, 2014 at 1:29 PM, Ondrej Zary <linux@rainbow-software.org> wrote:
>> Poll link status every 2 seconds instead of 60 for ADMtek Comet chips.
> 
> Why use 2 seconds for the polling interval?
> 
> I'm sure you have a good reason for this and it should be in the
> commit message or as a comment in the code.
> 
> I otherwise have no objection to this change.

Agreed, please post this with a better commit message, specifically
make sure you explain why the interval is being changed and why
2*HZ is specifically being choosen.

Thanks.
