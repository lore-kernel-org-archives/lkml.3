Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756971AbaD1UVB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 16:21:01 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:34276 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbaD1UU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 16:20:59 -0400
MIME-Version: 1.0
In-Reply-To: <CANGgnMahGUooVsRLuNd0UyA6bZk1=a_zL+Uqi7AGHrJn1EMxcg@mail.gmail.com>
References: <CANGgnMbszHzYe9pF2C6wag4MY_PfBG2qrMCC=rMmQnb-jyXXXw@mail.gmail.com>
	<52CAB05F.4010303@hartkopp.net>
	<CANGgnMZZu6tX0LyK4mQaYhixY9uhbQYee7XO5_HtNfT0REPghA@mail.gmail.com>
	<alpine.DEB.2.02.1404072040320.14882@ionos.tec.linutronix.de>
	<CANGgnMbXSosuUTy02QUuqM2bNomrusJVBN_=f6OE8f+NcAdwmQ@mail.gmail.com>
	<alpine.DEB.2.02.1404072206550.14882@ionos.tec.linutronix.de>
	<CANGgnMahGUooVsRLuNd0UyA6bZk1=a_zL+Uqi7AGHrJn1EMxcg@mail.gmail.com>
Date: Mon, 28 Apr 2014 13:20:58 -0700
Message-ID: <CANGgnMavy-W8UXosgBrLkSLU=rYvU36OJCE0qgZQ4N6iSdN82A@mail.gmail.com>
Subject: Re: [PATCH] genirq: Sanitize spurious interrupt detection of threaded irqs
From: Austin Schuh <austin@peloton-tech.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 7, 2014 at 1:08 PM, Austin Schuh <austin@peloton-tech.com> wrote:
> On Mon, Apr 7, 2014 at 1:07 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>> On Mon, 7 Apr 2014, Austin Schuh wrote:
>>> You originally sent the patch out.  I could send your patch out back
>>> to you, but that feels a bit weird ;)
>>
>> Wheee. Let me dig in my archives ....
>
> https://lkml.org/lkml/2013/3/7/222 in case that helps.

Did you find the patch?  I didn't see anything go by (but I'm not on
the main mailing list and didn't find anything with a quick Google
search.)  It would be nice to not need to run a custom kernel to keep
my machine running.  I have what is probably a year split between 2
machines of runtime with the patch applied, and I haven't seen any
problems with it.

Austin
