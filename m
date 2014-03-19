Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296AbaCSUE3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 16:04:29 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:38406 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbaCSUE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 16:04:28 -0400
Date: Wed, 19 Mar 2014 16:04:25 -0400 (EDT)
Message-Id: <20140319.160425.2139869352245055503.davem@davemloft.net>
To: benchan@chromium.org
Cc: bjorn@mork.no, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, oliver@neukum.org, gregkh@linuxfoundation.org,
        gsuarez@smithmicro.com
Subject: Re: [PATCH 2/2] net: cdc_ncm: respect operator preferred MTU
 reported by MBIM
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAC5Y2nNiTX4Qo9H6R2hh3PkVAfgK3tzuq4BtoOqeCq=aa0XUtg@mail.gmail.com>
References: <CAC5Y2nMdPM8w3=dgd2as5z8huL1XLPjon8wSmR-2e3=JGWtCpA@mail.gmail.com>
	<20140317.214148.2254695408331774828.davem@davemloft.net>
	<CAC5Y2nNiTX4Qo9H6R2hh3PkVAfgK3tzuq4BtoOqeCq=aa0XUtg@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Mar 2014 13:04:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Chan <benchan@chromium.org>
Date: Mon, 17 Mar 2014 21:00:06 -0700

> On Mon, Mar 17, 2014 at 6:41 PM, David Miller <davem@davemloft.net> wrote:
>> From: Ben Chan <benchan@chromium.org>
>> Date: Mon, 17 Mar 2014 17:46:27 -0700
>>
>>> Thanks again for the review and tip. I've submitted patch v2 to
>>> address the le16_to_cpu conversion.
>>
>> When you update a patch from a series, you should repost the entire
>> patch set, rather than just the patch which changes.
>>
>> This avoids any and all ambiguity of which patches go with which
>> others.
> 
> Thanks for pointing that out. I've submitted the whole patch set as v3
> (bumped the revision to avoid confusion).

I hate to ask for a repost, but:

1) Please put Greg KH's ACK into patch #1, patchwork doesn't carry ACKs
   from one submission to the next, as it shouldn't.

2) Please give a leading "[PATCH 0/2] ..." posting explaining at a high
   level what this series is doing.

Also, make it explicit what tree you want me to apply this too, and if
the changes are relevant for -stable.

