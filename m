Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669AbaBYWkM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 17:40:12 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:34788 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183AbaBYWkJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 17:40:09 -0500
MIME-Version: 1.0
In-Reply-To: <CAB=NE6WAmHqAYsh6rwyHdvZy3J6ck-uD_Kavk3qqy02vML359g@mail.gmail.com>
References: <1393287245-4549-1-git-send-email-mcgrof@do-not-panic.com>
 <1393294265.6823.154.camel@deadeye.wl.decadent.org.uk> <20140224.235343.1936318499491821387.davem@davemloft.net>
 <2446186.I4KkJ8Hjdb@lenovo> <CAB=NE6WAmHqAYsh6rwyHdvZy3J6ck-uD_Kavk3qqy02vML359g@mail.gmail.com>
From: Florian Fainelli <f.fainelli@gmail.com>
Date: Tue, 25 Feb 2014 14:39:28 -0800
Message-ID: <CAGVrzcaaViC10TvnSVBJsKRF3pSOvbP7Z+Kh4Qcu0RS_RY5GBA@mail.gmail.com>
Subject: Re: [PATCH] net: kdoc struct net_device flags and priv_flags
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: David Miller <davem@davemloft.net>, Ben Hutchings <ben@decadent.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-02-25 14:19 GMT-08:00 Luis R. Rodriguez <mcgrof@do-not-panic.com>:
> On Mon, Feb 24, 2014 at 9:37 PM, Florian Fainelli <f.fainelli@gmail.com> wrote:
>> Le lundi 24 février 2014, 23:53:43 David Miller a écrit :
>>> They are visible to userspace via sysfs.
>>
>> In /sys/class/net/*/flags, although we are lacking quite a lot of documentation
>> for the exported attributes there.
>
> I only see dev->flags there, I don't see any toggle capability for
> priv_flags. Let me know if you find anywhere that userspace lets a
> user toggle private flags, I just don't see it.

You are right, those are dev->flags, not priv_flags, sorry about that.

>
> I'll extend the documentation for a v2 with the sysfs attribute stuff.

Thanks!
-- 
Florian
