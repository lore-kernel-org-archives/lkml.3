Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583AbaFWRyB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 13:54:01 -0400
Received: from mail.active-venture.com ([67.228.131.205]:55361 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756112AbaFWRx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 13:53:59 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53A869AC.4020806@roeck-us.net>
Date: Mon, 23 Jun 2014 10:53:48 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andreas Mohr <andi@lisas.de>
CC: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/5] i8k: Fix non-SMP operation
References: <20140621185359.GA18900@rhlx01.hs-esslingen.de>
In-Reply-To: <20140621185359.GA18900@rhlx01.hs-esslingen.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2014 11:53 AM, Andreas Mohr wrote:
> Hi,
>
> I'd like to say Thank You for this fix especially and the series in
> general, as the (proud??) owner of an I8K (yes you read that right).
>
> My review of your impressive series ended up fine
> (I'm sure I'm now missing some official tag somewhere...).
>
Hi Andreas,

You could send a Reviewed-by: tag as response to each of the patches;
I am sure that would help. Tested-by: would be even better, of course.

Thanks,
Guenter


