Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340AbaE1XTx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 19:19:53 -0400
Received: from top.free-electrons.com ([176.31.233.9]:47759 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752546AbaE1XTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 19:19:52 -0400
Date: Thu, 29 May 2014 01:19:43 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Paul Bolle <pebolle@tiscali.nl>, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] misc: atmel_pwm: only build for supported platforms
Message-ID: <20140528231940.GC18470@piout.net>
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de>
 <1399560990-1402858-1-git-send-email-arnd@arndb.de>
 <1399560990-1402858-17-git-send-email-arnd@arndb.de>
 <536CA80A.60201@atmel.com>
 <1401279867.22486.6.camel@x220>
 <20140528155916.GA9793@piout.net>
 <1401293383.22486.18.camel@x220>
 <20140528175439.GA18470@piout.net>
 <1401299948.22486.51.camel@x220>
 <20140528184217.GB30031@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140528184217.GB30031@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/05/2014 at 11:42:17 -0700, Greg Kroah-Hartman wrote :
> On Wed, May 28, 2014 at 07:59:08PM +0200, Paul Bolle wrote:
> > So the patch we're discussing here will never be included in a release?
> 

As it hit linux-next, I guess it will be in 3.16

> So, should I just remove it right now?  I like deleting files :)
> 

I also like doing that, let me resend my series, rebased on linux-next
because of the dependency on the PWM tree. Then I will let you and
Nicolas decide what you want to do with it.

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
