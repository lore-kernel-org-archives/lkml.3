Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003Ab3JGRiz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 13:38:55 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:33242 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288Ab3JGRix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 13:38:53 -0400
Date: Mon, 07 Oct 2013 13:38:49 -0400 (EDT)
Message-Id: <20131007.133849.1821189531065820610.davem@davemloft.net>
To: ou.ghorbel@gmail.com
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix the upper MTU limit in ipv6 GRE tunnel
From: David Miller <davem@davemloft.net>
In-Reply-To: <CABfLueGqa8wJv+hfcNQRmWM2tj6zMC5Ajts=-no7GJA1t09dnQ@mail.gmail.com>
References: <1380880333-3546-1-git-send-email-ou.ghorbel@gmail.com>
	<20131007.125326.895480090584703586.davem@davemloft.net>
	<CABfLueGqa8wJv+hfcNQRmWM2tj6zMC5Ajts=-no7GJA1t09dnQ@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 07 Oct 2013 10:38:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oussama Ghorbel <ou.ghorbel@gmail.com>
Date: Mon, 7 Oct 2013 18:34:53 +0100

> OK, I've resubmitted the patch with the proper Subject line.
> The new mail subject is: [PATCH] ipv6: Fix the upper MTU limit in GRE tunnel

You forgot to propagate the "Acked-by: " tag that was given by
reviewers of your patch.
