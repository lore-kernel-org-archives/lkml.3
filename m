Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266AbaLVJpb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 04:45:31 -0500
Received: from down.free-electrons.com ([37.187.137.238]:59533 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754150AbaLVJpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 04:45:16 -0500
Date: Mon, 22 Dec 2014 10:45:12 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Valentin Rothberg <valentinrothberg@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [PATCH 1/4] ARM: at91: remove at91sam9263 legacy board support
Message-ID: <20141222094512.GA4194@piout.net>
References: <cover.1416392687.git.nicolas.ferre@atmel.com>
 <cf26d39a4a251662dbc363092b319b788d223a7b.1416392687.git.nicolas.ferre@atmel.com>
 <1417434775.30245.29.camel@x220>
 <547C92A1.8000902@atmel.com>
 <1419240528.30945.12.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419240528.30945.12.camel@x220>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On 22/12/2014 at 10:28:48 +0100, Paul Bolle wrote :
> > So, I suggest to get rid of them during 3.19-rc phase.
> 
> There's still an entry for RTC_DRV_AT91SAM9_RTT in next-20141221 (and
> v3.19-rc1). So this I send this message as a reminder that this cleanup
> is still needed.
> 

Thanks for the reminder, the pull request was actually waiting for
3.19-rc1 to get released before being sent. This should be solved in the
next rc.

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
