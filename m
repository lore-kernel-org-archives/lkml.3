Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690AbaJ0XFs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 19:05:48 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:57183 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbaJ0XFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 19:05:47 -0400
Message-ID: <544ECFB4.7040704@linux.com>
Date: Tue, 28 Oct 2014 00:05:24 +0100
From: Matthias Klein <matthias.klein@linux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>,
        linux-rpi-kernel@lists.infradead.org, linus.walleij@linaro.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] pinctrl: bcm2835: Start GPIO numeration at zero
References: <1414447799-1284-1-git-send-email-matthias.klein@linux.com> <544ECAB2.3060706@wwwdotorg.org>
In-Reply-To: <544ECAB2.3060706@wwwdotorg.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Am 27.10.2014 um 23:44 schrieb Stephen Warren:
> On 10/27/2014 04:09 PM, Matthias Klein wrote:
>> Numerate the GPIOs from 0..53 instead of 202..255.
>
> What's the motivation for this? The GPIO IDs should all come from DT, 
> which encodes everything as an ID relative to a particular 
> controllers, and hence the actual value of the base address should be 
> irrelevant.
- To be in sync with the GPIO numbers in the datasheet / documentation
- For userland applications which rely on these GPIO numbers

