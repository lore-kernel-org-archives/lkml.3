Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933217Ab3KMJIa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 04:08:30 -0500
Received: from www.linutronix.de ([62.245.132.108]:52024 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933456Ab3KMJIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 04:08:21 -0500
Message-ID: <52834182.6080501@linutronix.de>
Date: Wed, 13 Nov 2013 10:08:18 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: Clark Williams <williams@redhat.com>
CC: RT <linux-rt-users@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] 3.12.0-rt1: net: iwlwifi request only a threaded handler
 for interrupts
References: <20131112131659.578eb7c1@sluggy>
In-Reply-To: <20131112131659.578eb7c1@sluggy>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2013 08:16 PM, Clark Williams wrote:
> Sebastian,

Hi Clark,

> 
> I needed this for my laptop on 3.12, so tweaked it to apply
> properly.

The patch was a little broken but I managed to apply it. Thanks for
testing.

> 
> Clark

Sebastian
