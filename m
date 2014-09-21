Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429AbaIUTX1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 15:23:27 -0400
Received: from smtp-out-223.synserver.de ([212.40.185.223]:1057 "EHLO
	smtp-out-222.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752247AbaIUTX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 15:23:26 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 28962
Message-ID: <541F25AD.7030204@metafoo.de>
Date: Sun, 21 Sep 2014 21:23:25 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.8.0
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com
Subject: Re: [PATCH] i2c: Add generic support passing secondary devices addresses
References: <1409925739-28188-1-git-send-email-jean-michel.hautbois@vodalys.com> <20140920164858.GA2260@katana> <541DDA9B.40904@metafoo.de> <20140921174902.GA1479@katana>
In-Reply-To: <20140921174902.GA1479@katana>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2014 07:49 PM, Wolfram Sang wrote:
>
>>> This raises the first question for me: Are the additional addresses
>>> configurable? Sadly, I can't find good documentation for the adv7604.
>>> Otherwise, if I know I have a adv7604 and know its addresses, this
>>> information should go into the driver and not the DT.
>>>
>>
>> They are. The current driver hard codes the other addresses, but that's not
>> working when you have multiple adv7604s on the same I2C bus.
>
> How is this configured? I can't imagine every address has its own
> setting, but rather some 1-3 pins which select a certain block of
> addresses?
>

Every secondary address has its own register and can be set to any valid I2C 
address.

- Lars
