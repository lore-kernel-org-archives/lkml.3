Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494AbaBSMkr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 07:40:47 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:47157 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbaBSMkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 07:40:46 -0500
Message-ID: <5304A651.6080701@cogentembedded.com>
Date: Wed, 19 Feb 2014 16:40:49 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>, daeseok.youn@gmail.com
CC: tj@kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] atm: libahci: replace obselete simple_strtoul() with
 kstrtouint()
References: <1983660.RVkLooTtjT@daeseok-laptop.cloud.net> <20140219.010509.484470671732800480.davem@davemloft.net>
In-Reply-To: <20140219.010509.484470671732800480.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 19-02-2014 10:05, David Miller wrote:

>>  From 18bd7236f36a248a0871f810cec3c1e98f098a91 Mon Sep 17 00:00:00 2001
>> From: Daeseok Youn <daeseok.youn@gmail.com>
>> Date: Wed, 19 Feb 2014 13:44:24 +0900
>> Subject: [PATCH] atm: libahci: replace obselete simple_strtoul() with
>>   kstrtouint()

>> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>

> Please fix your Subject line, you meant "ata: " not "atm: "

    And "obsolete". :-)

WBR, Sergei

