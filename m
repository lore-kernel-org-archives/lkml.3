Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777Ab3IZGQL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 02:16:11 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:34060 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430Ab3IZGQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 02:16:07 -0400
Message-ID: <5243D11A.5090808@gmail.com>
Date: Thu, 26 Sep 2013 08:15:54 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 23/26] ARM: sunxi: remove custom .init_time hook
References: <1379526839-14798-1-git-send-email-sebastian.hesselbarth@gmail.com> <1379526839-14798-24-git-send-email-sebastian.hesselbarth@gmail.com> <20130925200731.GM2954@lukather>
In-Reply-To: <20130925200731.GM2954@lukather>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2013 10:07 PM, Maxime Ripard wrote:
> On Wed, Sep 18, 2013 at 07:53:56PM +0200, Sebastian Hesselbarth wrote:
>> With arch/arm calling of_clk_init(NULL) from time_init(), we can now
>> remove custom .init_time hooks.
>>
>> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>
> Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
>
> How do you want us to merge this? Every maintainer takes the patches he
> handles, or will Kevin and Olof merge the whole thing?

Maxime,

I am still waiting for some ACKs (nomadik, prima2, socfpga, nspire) and
possibly Mike's on the clock changes.

My current idea is to prepare a branch for Olof to pull in as whole.

Sebastian

