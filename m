Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749AbaBYWTy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 17:19:54 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:50264 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722AbaBYWTv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 17:19:51 -0500
MIME-Version: 1.0
In-Reply-To: <2446186.I4KkJ8Hjdb@lenovo>
References: <1393287245-4549-1-git-send-email-mcgrof@do-not-panic.com>
 <1393294265.6823.154.camel@deadeye.wl.decadent.org.uk> <20140224.235343.1936318499491821387.davem@davemloft.net>
 <2446186.I4KkJ8Hjdb@lenovo>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 25 Feb 2014 14:19:29 -0800
X-Google-Sender-Auth: YBQLLWK6jJNDngF0aqA-83_1Zi8
Message-ID: <CAB=NE6WAmHqAYsh6rwyHdvZy3J6ck-uD_Kavk3qqy02vML359g@mail.gmail.com>
Subject: Re: [PATCH] net: kdoc struct net_device flags and priv_flags
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: David Miller <davem@davemloft.net>, Ben Hutchings <ben@decadent.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 9:37 PM, Florian Fainelli <f.fainelli@gmail.com> wrote:
> Le lundi 24 février 2014, 23:53:43 David Miller a écrit :
>> They are visible to userspace via sysfs.
>
> In /sys/class/net/*/flags, although we are lacking quite a lot of documentation
> for the exported attributes there.

I only see dev->flags there, I don't see any toggle capability for
priv_flags. Let me know if you find anywhere that userspace lets a
user toggle private flags, I just don't see it.

I'll extend the documentation for a v2 with the sysfs attribute stuff.

  Luis
