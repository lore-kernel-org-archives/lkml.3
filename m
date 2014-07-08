Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733AbaGHVNb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 17:13:31 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:54258 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611AbaGHVN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 17:13:29 -0400
Date: Tue, 08 Jul 2014 14:13:28 -0700 (PDT)
Message-Id: <20140708.141328.1589777085621867948.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-next 2014-07-03
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140703204141.GD13303@tuxdriver.com>
References: <20140703191211.GB13303@tuxdriver.com>
	<20140703204141.GD13303@tuxdriver.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 08 Jul 2014 14:13:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Thu, 3 Jul 2014 16:41:42 -0400

> On Thu, Jul 03, 2014 at 03:12:11PM -0400, John W. Linville wrote:
>> Dave,
>> 
>> Please pull this first batch of wireless updates intended for the
>> 3.17 stream...
>> 
>> For the mac80211 bits, Johannes says:
>> 
>> "The biggest thing here is probably Arik's TDLS rework, beyond that we
>> have smaller improvements and features like David's scanning IE thing,
>> Luca's queue work, some CSA work, etc. Also your PID rate control
>> removal, of course."
>> 
>> For the iwlwifi bits, Emmanuel says:
>> 
>> "I have here a fix from Eliad for scheduled scan: it fixes a firmware
>> assertion. Arik reverts a patch I made that didn't take into account
>> that 3160 doesn't have UAPSD and hence, we can't assume that all
>> newer firmwares support the feature. Here too, the visible effect
>> is a firmware assertion. Along with that, we have a few fixes and
>> additions to the device list."
> 
> I copied the wrong text.  It should have read as follows:
> 
> "I have here a whole bunch of various things. Andy contributes
> better debug prints for dvm specific flows and a module parameter to
> completely disable power save for dvm. Andrei is sharing the premises
> of his work on CSA - more to come. Eran and Liad keep on working
> on the new devices. I have the regular amount of BT Coex stuff and
> I continue to work on the firmware error report system adding more
> debug capabilities. More to come on that subject too."
> 
> Sorry for the confusion!

I fixed the text up and pulled, thanks John.
