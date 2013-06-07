Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999Ab3FGH2g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 03:28:36 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:3542 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab3FGH2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 03:28:34 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 07 Jun 2013 00:27:46 -0700
Message-ID: <51B18B9D.1030901@nvidia.com>
Date: Fri, 7 Jun 2013 16:28:29 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Alexander van Heukelum <heukelum@fastmail.fm>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Olof Johansson <olof@lixom.net>, "gnurou@gmail.com" <gnurou@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH v2] simplefb: add support for a8b8g8r8 pixel format
References: <1370584869-2904-1-git-send-email-acourbot@nvidia.com> <1370589753.21409.140661241005617.2A5614D3@webmail.messagingengine.com>
In-Reply-To: <1370589753.21409.140661241005617.2A5614D3@webmail.messagingengine.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2013 04:22 PM, Alexander van Heukelum wrote:
>>   static struct simplefb_format simplefb_formats[] = {
>>   	{ "r5g6b5", 16, {11, 5}, {5, 6}, {0, 5}, {0, 0} },
>> +	{ "a8b8g8r8", 32, {0, 8}, {8, 8}, {16, 8}, {31, 8} },
>
> Hi,
>
> 31? I assume in practice this doesn't influence anything, but I think it should have read 24.

Doh. Thanks for pointing it out.

Alex.

