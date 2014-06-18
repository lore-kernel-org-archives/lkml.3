Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965598AbaFRJb0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 05:31:26 -0400
Received: from top.free-electrons.com ([176.31.233.9]:51855 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S964997AbaFRJbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 05:31:24 -0400
Date: Wed, 18 Jun 2014 11:31:09 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] misc: atmel_pwm: only build for supported platforms
Message-ID: <20140618093109.GQ19375@piout.net>
References: <1399560990-1402858-1-git-send-email-arnd@arndb.de>
 <1399560990-1402858-17-git-send-email-arnd@arndb.de>
 <536CA80A.60201@atmel.com>
 <1401279867.22486.6.camel@x220>
 <20140528155916.GA9793@piout.net>
 <1401293383.22486.18.camel@x220>
 <20140528175439.GA18470@piout.net>
 <1401299948.22486.51.camel@x220>
 <20140528184217.GB30031@kroah.com>
 <1403083170.1984.70.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403083170.1984.70.camel@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 18/06/2014 at 11:19:30 +0200, Paul Bolle wrote :
> This has landed unchanged in v3.16-rc1. Should I submit the trivial
> patch to remove these pointless references to the unknown symbols
> AT91SAM9263, AT91SAM9RL, and AT91SAM9G45?
> 

Because of dependencies, the pull request was delayed until after
3.16-rc1. It has been resent and this should be solved for 3.16-rc2:

http://lists.infradead.org/pipermail/linux-arm-kernel/2014-June/264181.html

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
