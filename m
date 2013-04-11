Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab3DKGxY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 02:53:24 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:50888 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924Ab3DKGxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 02:53:23 -0400
Message-ID: <51665DDF.4060205@gmail.com>
Date: Thu, 11 Apr 2013 08:53:19 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: buytenh@wantstofly.org, andrew@lunn.ch, jason@lakedaemon.net,
        florian@openwrt.org, sergei.shtylyov@cogentembedded.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: mv643xx_eth: use managed devm_kzalloc
References: <1365615483-26318-1-git-send-email-sebastian.hesselbarth@gmail.com> <1365626527-27233-1-git-send-email-sebastian.hesselbarth@gmail.com> <20130410.233933.2109788843089649198.davem@davemloft.net>
In-Reply-To: <20130410.233933.2109788843089649198.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2013 05:39 AM, David Miller wrote:
> From: Sebastian Hesselbarth<sebastian.hesselbarth@gmail.com>
> Date: Wed, 10 Apr 2013 22:42:07 +0200
>
>> This patch moves shared private data kzalloc to managed devm_kzalloc and
>> cleans now unneccessary kfree and error handling.
>>
>> Signed-off-by: Sebastian Hesselbarth<sebastian.hesselbarth@gmail.com>
>
> This doesn't apply cleanly to the net-next tree.

Yeah. I sent two single patches for mv643xx_eth, while they should
have been sent together in one patch set. I'll prepare a cover letter
and resend both in one patch set.

Sebastian
