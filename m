Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751561Ab3LJWYw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 17:24:52 -0500
Received: from plane.gmane.org ([80.91.229.3]:49622 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819Ab3LJWYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 17:24:49 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Subject: Re: [PATCH v2 02/11] arm: pxa27x: support ICP DAS LP-8x4x
Date: Tue, 10 Dec 2013 22:24:29 +0000 (UTC)
Message-ID: <l884at$icv$1@ger.gmane.org>
References: <1385879185-22455-3-git-send-email-ynvich@gmail.com>
	<1386348542-9584-1-git-send-email-ynvich@gmail.com>
	<CACRpkdYVsGSyMS6sSTqqJ4XrE3GqpWkJsY7GDazi5ix7xjKQ=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: ppp89-110-30-154.pppoe.avangarddsl.ru
User-Agent: Pan/0.139 (Sexual Chocolate; GIT bf56508
 git://git.gnome.org/pan2)
Cc: linux-arm-kernel@lists.infradead.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Dec 2013 13:43:27 +0100, Linus Walleij wrote:
 
> Argh! Now you're adding another user for a legacy custom pin control
> implementation. But if noone is going to modernize PXA2xx what can we do
> :-/

I plan to work on pxa2xx (pxa25x to be precise) after finishing with 
sa1100 - my second (well, first) PDA is Sharp SL-6000 (pxa255).

StrongARM somewhat resembles pxa2xx, so some of the drivers will be 
shared, some expertise will be shared, etc. I tried doing pxa first, but 
later found that it might be easier to update sa1100.

-- 
With best wishes
Dmitry

