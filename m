Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230Ab3AQWNj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 17:13:39 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:64993 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328Ab3AQWNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 17:13:37 -0500
Message-ID: <50F87785.6060302@gmail.com>
Date: Thu, 17 Jan 2013 23:13:25 +0100
From: Yacine Belkadi <yacine.belkadi.1@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "David S. Miller" <davem@davemloft.net>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, yacine.belkadi.1@gmail.com
Subject: Re: [PATCH] {cfg,mac}80211.h: fix some kernel-doc warnings
References: <1357995254-2318-1-git-send-email-yacine.belkadi.1@gmail.com>  (sfid-20130112_135436_590066_4364BBD9) <1358345501.22862.10.camel@jlt4.sipsolutions.net>
In-Reply-To: <1358345501.22862.10.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 01/16/2013 03:11 PM, Johannes Berg wrote:
> Hi,
> 
> I totally missed your email before.
> 
>> Warning(include/net/cfg80211.h:334): No description found for return value of       'cfg80211_get_chandef_type'
>>
>> These warnings are only reported when scripts/kernel-doc runs in verbose mode.
>>
>> Fix:
>> In comments, use "Return:" to describe function return values.
> 
> I wasn't even aware of this, is that new? Anyway, applied, thanks.

Yes, it's from December.
Here is the last thread: https://lkml.org/lkml/2012/11/26/709

Yacine
