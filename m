Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496Ab3FXKUh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 06:20:37 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:51120 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756Ab3FXKUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 06:20:36 -0400
MIME-Version: 1.0
In-Reply-To: <CAHOfOo21+hSwFrXZuoMppcivcOonhx-m1p-yyZsm6c5UCh0joQ@mail.gmail.com>
References: <CAHOfOo21+hSwFrXZuoMppcivcOonhx-m1p-yyZsm6c5UCh0joQ@mail.gmail.com>
From: Andrew Brooks <arb@sat.dundee.ac.uk>
Date: Mon, 24 Jun 2013 11:20:15 +0100
Message-ID: <CAHOfOo0kdByd3T0LL4tBpy-aFtJS6bRK7D=rPc6Si0iv03CLKQ@mail.gmail.com>
Subject: Re: niu lock-up (Transmit timed out, resetting) and NETDEV WATCHDOG
To: Linux Net-Dev Mailing List <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 March 2013 13:44, Andrew Brooks <arb@sat.dundee.ac.uk> wrote:
>
> Using niu driver for this card: Oracle/SUN Multithreaded 10-Gigabit
> Ethernet Network Controller and after a period the interface will hang
> with errors every 5 seconds
> "niu: xxx: eth2: Transmit timed out, resetting"
>
> Sometimes also in syslog are messages
> WARNING: at sch_generic:255 dev_watchdog
> NETDEV WATCHDOG: eth2 (niu): transmit queue 10 timed out

Do you think this could be caused by a problem I've seen reported
by other machines on the network
"received unsolicited ack for DL_UNITDATA_REQ on nxge0" ?
Is there some bad packet flying around that causes the
niu driver to lock up the kernel?
