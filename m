Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633Ab3JGStG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 14:49:06 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:34858 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384Ab3JGStE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 14:49:04 -0400
Date: Mon, 07 Oct 2013 14:48:57 -0400 (EDT)
Message-Id: <20131007.144857.493314402025122315.davem@davemloft.net>
To: ou.ghorbel@gmail.com
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix the upper MTU limit in ipv6 GRE tunnel
From: David Miller <davem@davemloft.net>
In-Reply-To: <CABfLueFg=tKUbZPvKFKJZviNE+x1K4akjY8aPX7otyf_9gkLQQ@mail.gmail.com>
References: <CABfLueGqa8wJv+hfcNQRmWM2tj6zMC5Ajts=-no7GJA1t09dnQ@mail.gmail.com>
	<20131007.133849.1821189531065820610.davem@davemloft.net>
	<CABfLueFg=tKUbZPvKFKJZviNE+x1K4akjY8aPX7otyf_9gkLQQ@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 07 Oct 2013 11:49:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oussama Ghorbel <ou.ghorbel@gmail.com>
Date: Mon, 7 Oct 2013 18:52:15 +0100

> Sorry for that. I've added  it and I have resubmitted the patch.

Thank you.
