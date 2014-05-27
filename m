Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068AbaE0JzQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 05:55:16 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:35352 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbaE0JzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 05:55:13 -0400
Date: Tue, 27 May 2014 10:55:08 +0100
From: Jamie Iles <jamie@jamieiles.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Linus Walleij <linus.walleij@linaro.org>, Jamie Iles <jamie@jamieiles.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Alan Tull <atull@altera.com>, Alexandre Courbot <gnurou@gmail.com>,
        linux-gpio@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>, dinguyen@altera.com
Subject: Re: [PATCH v3] gpio: dwapb: use a second irq chip
Message-ID: <20140527095508.GA25440@page.Home>
References: <CACRpkdY=oVyBCwRkppq11B0tkn2bMw+-h_fDhy538eatVUJ=pQ@mail.gmail.com>
 <1401137894-6096-1-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401137894-6096-1-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2014 at 10:58:14PM +0200, Sebastian Andrzej Siewior wrote:
> Right new have one irq chip running always in level mode. It would nicer
> to have two irq chips where one is handling level type interrupts and
> the other one is doing edge interrupts. So we can have at runtime two users
> where one is using edge and the other level.
> 
> Acked-by: Alan Tull <delicious.quinoa@gmail.com>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Acked-by: Jamie Iles <jamie@jamieiles.com>
