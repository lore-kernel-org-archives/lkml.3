Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbaBZWC3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 17:02:29 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:41367 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbaBZWC1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 17:02:27 -0500
Date: Wed, 26 Feb 2014 17:02:25 -0500 (EST)
Message-Id: <20140226.170225.656093339124352084.davem@davemloft.net>
To: bjorn@mork.no
Cc: freddy@asix.com.tw, netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, keithp@keithp.com
Subject: Re: [PATCH 1/1] AX88179_178A: Add VID:DID for Lenovo OneLinkDock
 Gigabit LAN
From: David Miller <davem@davemloft.net>
In-Reply-To: <87fvn57dn1.fsf@nemi.mork.no>
References: <87lhwx7f19.fsf@nemi.mork.no>
	<20140226.161659.2024676575146527914.davem@davemloft.net>
	<87fvn57dn1.fsf@nemi.mork.no>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Feb 2014 14:02:27 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bjørn Mork <bjorn@mork.no>
Date: Wed, 26 Feb 2014 22:44:18 +0100

> David Miller <davem@davemloft.net> writes:
>> From: Bjørn Mork <bjorn@mork.no>
>>
>>> No, sorry for being confusing.  The patch is fine.  But Keith sent it
>>> first...
>>
>> Did I apply Keith's patch?
> 
> No, you didn't.  And when I went looking at it now, I see why: It was
> posted to linux-usb and linux-kernel but not to netdev:
> http://www.kernelhub.org/?msg=420289&p=2
> 
>> If not, should I apply it instead?
> 
> The patches are identical except for the author and a minor difference
> in the device description string. 
> 
> It doesn't matter to me which patch you apply, and I absolutely don't
> think it's my place to tell you which patches to apply or not :-)

Fair enough, I'll apply this one, thanks!
