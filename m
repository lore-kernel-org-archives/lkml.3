Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758813Ab3EWNAP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 09:00:15 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:27336 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758433Ab3EWNAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 09:00:13 -0400
Message-ID: <519E12D8.4070903@atmel.com>
Date: Thu, 23 May 2013 15:00:08 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        boris brezillon <b.brezillon@overkiz.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Andrew Victor <linux@maxim.org.za>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] ARM: at91: move at91 aic driver to drivers/irqchip
References: <1369299909-10078-1-git-send-email-b.brezillon@overkiz.com> <1369299909-10078-2-git-send-email-b.brezillon@overkiz.com> <20130523090611.GG9937@game.jcrosoft.org> <519DE6A8.6040502@overkiz.com> <20130523120920.1df8e23a@skate> <20130523100951.GH9937@game.jcrosoft.org> <20130523122000.22a9a4d0@skate> <20130523102601.GI9937@game.jcrosoft.org> <20130523132255.3acf4431@skate>
In-Reply-To: <20130523132255.3acf4431@skate>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/05/2013 13:22, Thomas Petazzoni :
> Dear Jean-Christophe PLAGNIOL-VILLARD,

[..]

> It would be good if the other AT91 maintainers could raise their voice
> here, so that Boris knows whether it is worthwhile doing additional
> revisions of this patch set.

Guys, I do not like the role that I am forced to play...

Anyway, Boris I do like the intention of this patch series and be sure 
that we will integrate it as soon as it is ready.

Bye,
-- 
Nicolas Ferre
