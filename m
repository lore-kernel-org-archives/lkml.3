Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726AbaBSV1J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 16:27:09 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:46912 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbaBSV1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 16:27:07 -0500
Date: Wed, 19 Feb 2014 16:23:12 -0500 (EST)
Message-Id: <20140219.162312.1711517042878098859.davem@davemloft.net>
To: haiyangz@microsoft.com
Cc: netdev@vger.kernel.org, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org
Subject: Re: [PATCH net-next] hyperv: Add latest NetVSP versions to auto
 negotiation
From: David Miller <davem@davemloft.net>
In-Reply-To: <1392755334-25884-1-git-send-email-haiyangz@microsoft.com>
References: <1392755334-25884-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Feb 2014 13:27:07 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Tue, 18 Feb 2014 12:28:54 -0800

> +	u32 ver_list[] = {NVSP_PROTOCOL_VERSION_1, NVSP_PROTOCOL_VERSION_2,
> +		NVSP_PROTOCOL_VERSION_4, NVSP_PROTOCOL_VERSION_5};

Please put a space after "{" and before "}".

> +	int i, num_ver = 4; /* number of different NVSP versions */
> +
>  
>  	net_device = get_outbound_net_device(device);

Please delete the extraneous empty line.

> +	for (i = num_ver - 1; i >= 0; i--)
> +		if (negotiate_nvsp_ver(device, net_device, init_packet,
> +			ver_list[i])  == 0) {

This is not indented properly, "ver_list[i])" should begin precisely after
the openning parenthesis of the negotiate_nvsp_ver() function call.

