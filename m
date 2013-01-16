Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073Ab3APWsm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 17:48:42 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:57216 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758016Ab3APWsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 17:48:40 -0500
Date: Wed, 16 Jan 2013 23:48:39 +0100
From: Andreas Mohr <andi@lisas.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] irq_work changes for 3.9
Message-ID: <20130116224839.GA32240@rhlx01.hs-esslingen.de>
References: <1358345841-29136-1-git-send-email-fweisbec@gmail.com>
 <20130116220447.GA20148@rhlx01.hs-esslingen.de>
 <CAFTL4hzeCGR2ygqqB8mxuVzduVbx7YOOm98EMoxR25x5pFiYHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFTL4hzeCGR2ygqqB8mxuVzduVbx7YOOm98EMoxR25x5pFiYHA@mail.gmail.com>
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[trimmed recipient list]

On Wed, Jan 16, 2013 at 11:12:09PM +0100, Frederic Weisbecker wrote:
> 2013/1/16 Andreas Mohr <andi@lisas.de>:
> > Hell yeah that does sound like a potential candidate to me.
> >
> > Andreas Mohr
> 
> I doubt it. I don't see a sound driver using struct irq_work:
> 
> $git grep -F "struct irq_work" drivers/ sound/

Even a more liberal search comes up similar.
I didn't know that irq_work is a somewhat more specific mechanism,
thank you for the clarification!

Leaves me wondering what actually could be responsible for this...
(perhaps even a userland bug i.e. PA buffer replenishing issues)

Oh well...

Andreas Mohr
