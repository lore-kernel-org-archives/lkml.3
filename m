Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082Ab3AWSuJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 13:50:09 -0500
Received: from antcom.de ([188.40.178.216]:47049 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751718Ab3AWSuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 13:50:06 -0500
Message-ID: <51003056.9080605@antcom.de>
Date: Wed, 23 Jan 2013 19:47:50 +0100
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.11) Gecko/20121122 Icedove/10.0.11
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: gregkh@linuxfoundation.org, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, w.sang@pengutronix.de,
        jbe@pengutronix.de, plagnioj@jcrosoft.com, highguy@gmail.com,
        broonie@opensource.wolfsonmicro.com, daniel-gl@gmx.net,
        rmallon@gmail.com, sr@denx.de, wg@grandegger.com, mark.rutland@arm.com,
        nicolas.ferre@atmel.com
Subject: Re: [PATCH 3/6 v14] gpio: Add userland device interface to block
 GPIO
References: <1358856404-8975-1-git-send-email-stigge@antcom.de> <1358856404-8975-4-git-send-email-stigge@antcom.de> <20130122180349.068f2c6a@lwn.net>
In-Reply-To: <20130122180349.068f2c6a@lwn.net>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/01/13 02:03, Jonathan Corbet wrote:
> On Tue, 22 Jan 2013 13:06:41 +0100
> Roland Stigge <stigge@antcom.de> wrote:
> 
>> This patch adds a character device interface to the block GPIO system.
> 
> So I was looking at this, and a couple of things caught my eye...

Good points you mentioned. Will address them on a subsequent update.

Thanks,

Roland
