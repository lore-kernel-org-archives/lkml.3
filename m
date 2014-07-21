Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747AbaGUISF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 04:18:05 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65276 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753715AbaGUISA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 04:18:00 -0400
Message-ID: <53CCCCAD.7080906@nod.at>
Date: Mon, 21 Jul 2014 10:17:49 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Yue Zhang (OSTC DEV)" <yuezha@microsoft.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>, Thomas Shao <huishao@microsoft.com>,
        Dexuan Cui <decui@microsoft.com>
Subject: Re: [PATCH] Hyperv: Trigger DHCP renew after host hibernation
References: <1405680903-28176-1-git-send-email-yuezha@microsoft.com> <CAFLxGvxQU_z+mChHsNSu9VZEdXrU+RU75k6H18uKbdAj2TKD5g@mail.gmail.com> <DC7803B42427924284F2D5252E076A3B44769DCA@SINEX14MBXC416.southpacific.corp.microsoft.com> <53CCB944.8090709@nod.at> <DC7803B42427924284F2D5252E076A3B4476A363@SINEX14MBXC416.southpacific.corp.microsoft.com>
In-Reply-To: <DC7803B42427924284F2D5252E076A3B4476A363@SINEX14MBXC416.southpacific.corp.microsoft.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yue,

Am 21.07.2014 10:05, schrieb Yue Zhang (OSTC DEV):
> The problem of systemd implementation is that in different distros, the ways to 
> restart service are different. Propagating the event to userspace also doesn't help
> for this issue. 

This way each distro can provide their own restart script.
Same as every distro has custom start scripts, etc...

> The advantage of current solution is that it simulates a cable plugging in/out event.
> IMHO, in all the distros, this simulated event has already been well handled. It is a
> dup effect to implement new hooks.

Iff the current solution works for _all_ networking implementations.

Thanks,
//richard
