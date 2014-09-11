Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272AbaIKRER (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 13:04:17 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:57989 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbaIKREN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 13:04:13 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <5411C810.7070906@linutronix.de>
References: <1410377411-26656-1-git-send-email-bigeasy@linutronix.de> <1410377411-26656-10-git-send-email-bigeasy@linutronix.de> <20140911111721.GB17476@xps8300> <54118AAB.2010205@linutronix.de> <5411967A.6090406@hurleysoftware.com> <54119AAA.9080907@linutronix.de> <20140911151114.GD28458@ci00147.xsens-tech.local> <5411C810.7070906@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH 09/16] tty: serial: 8250_dma: Add a TX trigger workaround for AM33xx
From: Frans Klaver <fransklaver@gmail.com>
Date: Thu, 11 Sep 2014 19:04:03 +0200
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Frans Klaver <frans.klaver@xsens.com>
CC: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Peter Hurley <peter@hurleysoftware.com>, tony@atomide.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        linux-serial@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Alan Cox <alan@linux.intel.com>
Message-ID: <2cf997d9-e7de-465b-915d-3a0a5e7b95f7@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 September 2014 18:04:32 CEST, Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:
>On 09/11/2014 05:11 PM, Frans Klaver wrote:
>
>> I can still reproduce it on am335x. I can get out of it as soon as
>> something else gets written to the console though.
>> 
>> # echo "<3>something" >/dev/kmsg
>
>Is this to stall it or to get out of it?

This is to get out of it. I do this from an ssh connection after the console got stuck. The 3 kind of ensures the message is actually sent to ttyS0.


>
>> 
>> Frans
>
>Sebastian
>
>_______________________________________________
>linux-arm-kernel mailing list
>linux-arm-kernel@lists.infradead.org
>http://lists.infradead.org/mailman/listinfo/linux-arm-kernel


