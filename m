Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbaBZTEj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 14:04:39 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:39966 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922AbaBZTEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 14:04:36 -0500
Message-ID: <530E48CC.3040304@cogentembedded.com>
Date: Wed, 26 Feb 2014 23:04:28 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Alexandre Courbot <gnurou@gmail.com>
CC: davinci-linux-open-source@linux.davincidsp.com,
        Samuel Ortiz <sameo@linux.intel.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-gpio@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        linux-input@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 0/5] ARM: davinci: tnetv107x removal
References: <1393418614-3968549-1-git-send-email-arnd@arndb.de> <201402261446.29257.arnd@arndb.de>
In-Reply-To: <201402261446.29257.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 02/26/2014 04:46 PM, Arnd Bergmann wrote:

>> The five patches are completely independent of one another,
>> and applying them out of order is fine since we just want
>> to remove the code. However, I'm looking for an Ack from
>> Cyril Chemparathy and Sekhar Nori first, to be sure we
>> won't need this code in the future. Kevin Hilman has
>> already mentioned that he sees no reason to keep this
>> code.

> Hmm, apparently Cyril is no longer at TI. If anyone has his
> current email address and thinks he might have an opinion,
> could you forward the original email?

    Done. Fished his Gmail address from LinkedIn.

> 	Arnd

WBR, Sergei

