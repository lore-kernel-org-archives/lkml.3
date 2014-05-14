Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007AbaENPvu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 11:51:50 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:56625 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754449AbaENPvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 11:51:49 -0400
Message-ID: <53739108.40209@ahsoftware.de>
Date: Wed, 14 May 2014 17:51:36 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org
CC: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>, Jon Loeliger <jdl@jdl.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [RFC PATCH 2/9] dt: deps: dependency based device creation
References: <1399913280-6915-1-git-send-email-holler@ahsoftware.de>	<1399913280-6915-3-git-send-email-holler@ahsoftware.de> <20140514140534.897F8C4153D@trevor.secretlab.ca>
In-Reply-To: <20140514140534.897F8C4153D@trevor.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 14.05.2014 16:05, schrieb Grant Likely:

>> +
>> +	if (graph.finished)
>> +		return -EINVAL; /* cycle found */
>> +
>> +	/* of_init_print_order(); */
>
> If you wrap of_init_print_order with a #ifdef DEBUG/#else/#endif, then
> you don't need to comment out the call to of_init_print_order().

To explain why I didn't use DEBUG here: DEBUG enables a lot of 
distracting messages. which is true for CONFIG_DEBUG_DRIVER too. 
Therefor I often prefer to use just pr_info("AHO: ..."); with which I 
print only stuff I want (and can easily grep for).

And as said, the patches I presented are meant for evaluation. I did 
patches without discussing them before in order to avoid endless 
discussion which likely never would have found an end and therfor would 
have prevented a start. So now you already have some to play and test 
with, without anyone had to discuss stuff before. ;)

Regards,

Alexander Holler

