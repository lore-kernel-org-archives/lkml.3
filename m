Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678Ab3ELP00 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 11:26:26 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:60398 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553Ab3ELP0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 11:26:24 -0400
Message-ID: <518FB49B.7030708@cogentembedded.com>
Date: Sun, 12 May 2013 19:26:19 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC 17/42] drivers/net/ethernet/renesas: don't check resource
 with devm_ioremap_resource
References: <1368173847-5661-1-git-send-email-wsa@the-dreams.de> <1368173847-5661-18-git-send-email-wsa@the-dreams.de> <518EAB9B.8040106@cogentembedded.com> <20130512094202.GA3039@katana>
In-Reply-To: <20130512094202.GA3039@katana>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 12-05-2013 13:42, Wolfram Sang wrote:

>> You should really compile-test your patches.

> Easier said than done with a cleanup series touching various platforms
> and architectures. If there are already solutions how to find a .config
> compiling the source file modified, I am all ears.

    You can always try to do:

$ make drivers/net/ethernet/renesas/sh_eth.o

with a .config file you have. It will compile a file regardless of 
whether it's enabled in your .config or not...

> That being said, the actual mistake I did was embarassing, I agree. I am
> sorry for that and will improve. And, doing things means doing mistakes,
> too.

    Be more attentive in the future please. :-)

> Regards,

>     Wolfram

WBR, Sergei

