Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758169AbaHZNZN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 09:25:13 -0400
Received: from mail.active-venture.com ([67.228.131.205]:51404 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754925AbaHZNZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 09:25:11 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53FC8AB3.2080603@roeck-us.net>
Date: Tue, 26 Aug 2014 06:25:07 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: Jonathan Cameron <jic23@kernel.org>, Adam.Thomson.Opensource@diasemi.com,
        knaack.h@gmx.de, lars@metafoo.de, pmeerw@pmeerw.net,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iio: core: Propagate error codes from OF layer to client
 drivers
References: <1408971437-10751-1-git-send-email-iivanov@mm-sol.com>	 <53FB5FF7.8020504@kernel.org> <20140825165430.GB14614@roeck-us.net> <1409039490.5256.75.camel@iivanov-dev>
In-Reply-To: <1409039490.5256.75.camel@iivanov-dev>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2014 12:51 AM, Ivan T. Ivanov wrote:
> Hi,
>
[ ... ]
>
> Another, less intrusive, solution will be if we revert last patch and explicitly
> check for EPROBE_DEFER on of_ by_name() return. How this sounds?
>
How is that different to the just accepted patch ?

Guenter

