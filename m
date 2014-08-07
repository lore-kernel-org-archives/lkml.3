Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101AbaHGWhb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 18:37:31 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:46065 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbaHGWh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 18:37:29 -0400
MIME-Version: 1.0
In-Reply-To: <20140721.143225.2040366896972949930.davem@davemloft.net>
References: <DC7803B42427924284F2D5252E076A3B4476A479@SINEX14MBXC416.southpacific.corp.microsoft.com>
	<53CCD6F2.6020909@nod.at>
	<20140721091851.GA28171@aepfle.de>
	<20140721.143225.2040366896972949930.davem@davemloft.net>
Date: Fri, 8 Aug 2014 00:37:28 +0200
Message-ID: <CAFLxGvyfy1UkxN6_-c_ST7f8n7DvqYsCPKChWmt9CerWb0dh7g@mail.gmail.com>
Subject: Re: [PATCH] Hyperv: Trigger DHCP renew after host hibernation
From: Richard Weinberger <richard.weinberger@gmail.com>
To: David Miller <davem@davemloft.net>, Yue Zhang <yuezha@microsoft.com>
Cc: "olaf@aepfle.de" <olaf@aepfle.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        driverdev-devel@linuxdriverproject.org,
        LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>, haiyangz@microsoft.com,
        "K. Y. Srinivasan" <kys@microsoft.com>, huishao@microsoft.com,
        decui@microsoft.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 11:32 PM, David Miller <davem@davemloft.net> wrote:
> From: Olaf Hering <olaf@aepfle.de>
> Date: Mon, 21 Jul 2014 11:18:51 +0200
>
>> On Mon, Jul 21, Richard Weinberger wrote:
>>
>>> My concern is that 10 seconds is maybe not a the right choice.
>>> (As we cannot know all implementations)
>>
>> Until someone reports an issue with it, 10 is fine. Just like 20 or 666.
>
> Wrong, this is policy and belongs in userspace.

The "/etc/init.d/network restart" nonsense now hit Linus' tree.
Yue, what is your proposal to fix that?

-- 
Thanks,
//richard
