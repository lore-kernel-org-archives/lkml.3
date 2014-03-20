Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733AbaCTDlt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 23:41:49 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:41725 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbaCTDls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 23:41:48 -0400
Date: Wed, 19 Mar 2014 23:41:46 -0400 (EDT)
Message-Id: <20140319.234146.1635130348995174527.davem@davemloft.net>
To: sergei.shtylyov@cogentembedded.com
Cc: haiyangz@microsoft.com, netdev@vger.kernel.org, kys@microsoft.com,
        olaf@aepfle.de, jasowang@redhat.com, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org
Subject: Re: [PATCH net-next,v3] hyperv: Add support for virtual Receive
 Side Scaling (vRSS)
From: David Miller <davem@davemloft.net>
In-Reply-To: <532A1275.2020208@cogentembedded.com>
References: <1395180922-2776-1-git-send-email-haiyangz@microsoft.com>
	<20140319.164005.1815461875771862691.davem@davemloft.net>
	<532A1275.2020208@cogentembedded.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Mar 2014 20:41:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Date: Thu, 20 Mar 2014 00:56:05 +0300

> Hello.
> 
> On 03/19/2014 11:40 PM, David Miller wrote:
> 
>>> +extern u8 netvsc_hash_key[];
> 
>> We no longer use extern in header file function declarations.
> 
>    Wait, this is a variable declaration. :-)

My bad :)
