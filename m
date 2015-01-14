Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074AbbANVw1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 16:52:27 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:45704 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123AbbANVwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 16:52:24 -0500
Date: Wed, 14 Jan 2015 16:52:20 -0500 (EST)
Message-Id: <20150114.165220.2282566005036464131.davem@davemloft.net>
To: xander.huff@ni.com
Cc: nicolas.ferre@atmel.com, netdev@vger.kernel.org, jaeden.amero@ni.com,
        rich.tollerton@ni.com, ben.shelton@ni.com, brad.mouring@ni.com,
        linux-kernel@vger.kernel.org, cyrille.pitchen@atmel.com
Subject: Re: [PATCH 1/2] fixup! net/macb: Adding comments to various #defs
 to make interpretation easier
From: David Miller <davem@davemloft.net>
In-Reply-To: <54B6DD2A.1050502@ni.com>
References: <1421266881-17314-1-git-send-email-xander.huff@ni.com>
	<20150114.160929.619787519481343067.davem@davemloft.net>
	<54B6DD2A.1050502@ni.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 14 Jan 2015 13:52:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xander Huff <xander.huff@ni.com>
Date: Wed, 14 Jan 2015 15:18:34 -0600

> On 1/14/2015 3:09 PM, David Miller wrote:
>>
>> As I mentioned, this won't do.
>>
>> I've already applied your original patches to net-next, therefore you
>> will
>> have to submit fixups relative to that.
>>
> These fixup commits are relative to an updated net-next, specifically
> "237de6e Merge branch 'hip04'".
> 
> Do you need them relative to (what I'm seeing is the latest) "2733135
> Merge branch 'vxlan_rco'"?

Why don't you make your subject lines and commit messages just say what
they are doing, rather than just saying "fix this other change"?
