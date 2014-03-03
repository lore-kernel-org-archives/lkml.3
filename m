Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646AbaCCQqh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 11:46:37 -0500
Received: from top.free-electrons.com ([176.31.233.9]:35891 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751812AbaCCQqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 11:46:36 -0500
Date: Mon, 3 Mar 2014 17:46:34 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>
Subject: Re: [PATCH] usb: gadget: atmel_usba: fix crash when no endpoint are
 specified
Message-ID: <20140303164633.GB3155@piout.net>
References: <1393515733-15764-1-git-send-email-alexandre.belloni@free-electrons.com>
 <53109EBE.4020900@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53109EBE.4020900@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On 28/02/2014 at 15:35:42 +0100, Nicolas Ferre wrote :
> On 27/02/2014 16:42, Alexandre Belloni :
> > If no endpoints are present in the device tree, the kernel will cras hwith the
> 
> s/cras hwith/crash with/
> 

Do you want me to send a v2 with that typo corrected or could you
correct it when applying ?


-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
