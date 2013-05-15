Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757640Ab3EOIxb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 04:53:31 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:52280 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756980Ab3EOIx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 04:53:28 -0400
Message-ID: <51934D03.1090400@free-electrons.com>
Date: Wed, 15 May 2013 10:53:23 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Emilio_L=F3pez?= <emilio@elopez.com.ar>
CC: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: sun5i: Update the clock compatible strings
References: <1367315783-21345-1-git-send-email-maxime.ripard@free-electrons.com> <1367315783-21345-3-git-send-email-maxime.ripard@free-electrons.com> <517FABBA.5060902@elopez.com.ar>
In-Reply-To: <517FABBA.5060902@elopez.com.ar>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 30/04/2013 13:32, Emilio López a écrit :
> Hi Maxime,
> 
> El 30/04/13 06:56, Maxime Ripard escribió:
>> The Allwinner A13 has a smaller clock set than the one found in the A10.
>> Fix the A13 device tree and documentation to reflect this.
>>
>> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> 
> The patch looks fine to me.
> 
> Acked-by: Emilio López <emilio@elopez.com.ar>

Ok, I just applied it to sunxi/dt-for-3.11

Maxime

-- 
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
