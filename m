Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616AbaBZVO2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 16:14:28 -0500
Received: from canardo.mork.no ([148.122.252.1]:60739 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999AbaBZVOZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 16:14:25 -0500
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: David Miller <davem@davemloft.net>
Cc: freddy@asix.com.tw, netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] AX88179_178A: Add VID:DID for Lenovo OneLinkDock Gigabit LAN
Organization: m
References: <1393404871-2248-1-git-send-email-freddy@asix.com.tw>
	<87zjle6pif.fsf@nemi.mork.no>
	<20140226.154801.1466276966991949680.davem@davemloft.net>
Date: Wed, 26 Feb 2014 22:14:10 +0100
In-Reply-To: <20140226.154801.1466276966991949680.davem@davemloft.net> (David
	Miller's message of "Wed, 26 Feb 2014 15:48:01 -0500 (EST)")
Message-ID: <87lhwx7f19.fsf@nemi.mork.no>
User-Agent: Gnus/5.130009 (Ma Gnus v0.9) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> From: Bjørn Mork <bjorn@mork.no>
> Date: Wed, 26 Feb 2014 13:13:12 +0100
>
>> freddy@asix.com.tw writes:
>> 
>>> From: Freddy Xin <freddy@asix.com.tw>
>>>
>>> Add VID:DID for Lenovo OneLinkDock Gigabit LAN
>> 
>> This is the same patch Keith Packard sent, but with a slighly different
>> description.  I take that as another proof that we should not attempt to
>> describe devices in these drivers.  Describe the driver instead.
>
> Are you saying that this patch needs to be implemented differently?

No, sorry for being confusing.  The patch is fine.  But Keith sent it
first...

The other comment is more of a personal opinion on the driver style.  In
any case, it's something that can be fixed up later. If at all.


Bjørn
