Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508Ab3HSL7i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 07:59:38 -0400
Received: from [94.18.233.162] ([94.18.233.162]:4446 "EHLO mail.secomea.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751275Ab3HSL7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 07:59:37 -0400
Message-ID: <521208A0.5010602@secomea.dk>
Date: Mon, 19 Aug 2013 13:59:28 +0200
From: =?ISO-8859-1?Q?Svenning_S=F8rensen?= <sss@secomea.dk>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Julia Lawall <julia.lawall@lip6.fr>
CC: Felipe Balbi <balbi@ti.com>, kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] usb: musb: dsps: simplify platform_get_resource_byname/devm_ioremap_resource
References: <1376902316-18520-1-git-send-email-Julia.Lawall@lip6.fr> <1376902316-18520-5-git-send-email-Julia.Lawall@lip6.fr> <5211FED3.4090102@secomea.dk> <alpine.DEB.2.02.1308191334340.2313@hadrien>
In-Reply-To: <alpine.DEB.2.02.1308191334340.2313@hadrien>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 19-08-2013 13:35, Julia Lawall wrote:
>    	reg_base = devm_ioremap_resource(dev, r);
>    	if (!musb->ctrl_base)
>    		return -EINVAL;
>> Not really related to Julia's patch, apart from making it more obvious that
>> there's a bug here.
>> I believe it is reg_base that needs to be checked, right?
> Indeed, it is all backwards.  I could extend the patch, if you want.
>
I'll let Felipe decide on that, but I can't imagine any objections.
IS_ERR() is the proper test, of course :)

Svenning
