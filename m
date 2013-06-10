Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321Ab3FJLDF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 07:03:05 -0400
Received: from relay-s04-hub004.domainlocalhost.com ([74.115.207.103]:4130
	"EHLO relay-S04-HUB004.domainlocalhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752347Ab3FJLDD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 07:03:03 -0400
Message-ID: <51B5B262.6000705@cypress.com>
Date: Mon, 10 Jun 2013 14:02:58 +0300
From: Ferruh Yigit <fery@cypress.com>
Organization: Cypress
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.input,gmane.linux.kernel
To: Javier Martinez Canillas <javier@dowhile0.org>
CC: Matthias Kaehlcke <matthias.list@kaehlcke.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Kevin McNeely <kev@cypress.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cyttsp: Fix swap of mfg_stat and mfg_cmd registers
References: <20130604211930.GF3618@raspi> <CABxcv=m91Q51vYQ-EMCfjTrvinOij_=bTg_vjXrYf7=nYhUbdA@mail.gmail.com>
In-Reply-To: <CABxcv=m91Q51vYQ-EMCfjTrvinOij_=bTg_vjXrYf7=nYhUbdA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2013 12:21 PM, Javier Martinez Canillas wrote:
> On Tue, Jun 4, 2013 at 11:19 PM, Matthias Kaehlcke
> <matthias.list@kaehlcke.net> wrote:
>> The command and status register in the driver were swapped with
>> respect to the order specified in the datasheet (CY8CTMA140).
>> Confirmed with Cypress that the order in the datasheet is correct.
>>
>> Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>
>> ---
>
> Acked-by: Javier Martinez Canillas <javier@dowhile0.org>

Acked-by: Ferruh Yigit <fery@cypress.com>


This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.
