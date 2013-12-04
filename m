Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab3LDBiF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 20:38:05 -0500
Received: from mail.fpasia.hk ([202.130.89.98]:51112 "EHLO fpa01n0.fpasia.hk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753139Ab3LDBiC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 20:38:02 -0500
Message-ID: <529E8773.1010505@gtsys.com.hk>
Date: Wed, 04 Dec 2013 09:37:55 +0800
From: Chris Ruehl <chris.ruehl@gtsys.com.hk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Icedove/3.0.11 ThunderBrowse/3.8
MIME-Version: 1.0
To: Marc Kleine-Budde <mkl@pengutronix.de>
CC: peter.chen@freescale.com, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3 v4] usb: chipidea: Reallocate regmap only if lpm is
 detected
References: <1386057710-3848-1-git-send-email-chris.ruehl@gtsys.com.hk> <529DBC81.5030805@pengutronix.de>
In-Reply-To: <529DBC81.5030805@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> @@ -642,6 +643,10 @@ static int ci_hdrc_probe(struct platform_device *pdev)
>>   			: CI_ROLE_GADGET;
>>   	}
>>
>> +	/* only update vbus status for peripheral */
>> +	if (ci->role == CI_ROLE_GADGET)
>> +		ci_handle_vbus_change(ci);
>> +
>
> This change seems unrelated to me.
>
> Marc

My fault I test a patch from Fabio on the wrong working branch. I must be
more careful.

Chris
