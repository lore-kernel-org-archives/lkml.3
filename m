Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378AbaKXRtz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 12:49:55 -0500
Received: from www.linutronix.de ([62.245.132.108]:40389 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754296AbaKXRtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 12:49:53 -0500
Message-ID: <54736FBE.6060505@linutronix.de>
Date: Mon, 24 Nov 2014 18:49:50 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: balbi@ti.com, George Cherian <george.cherian@ti.com>
CC: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: musb: core: Disable the Interrupts till BABBLE is
 fully handled
References: <1415953486-6000-1-git-send-email-george.cherian@ti.com> <20141118211734.GA19146@saruman>
In-Reply-To: <20141118211734.GA19146@saruman>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2014 10:17 PM, Felipe Balbi wrote:
> I think the driver is mis-detecting Babble. A babble only occurs when
> the device side tries to move data without the host asking for anything.

It also occurs if the device moves more than packet_size bytes. Not
really helping, I know…

Sebastian
