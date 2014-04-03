Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845AbaDCP6Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 11:58:25 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:47557 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664AbaDCP6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 11:58:22 -0400
Message-ID: <533D8518.1010306@ahsoftware.de>
Date: Thu, 03 Apr 2014 17:58:16 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH regression] net: phy: fix initialization (config_init)
 for Marvel 88E1116R PHYs
References: <1396396559-6971-1-git-send-email-holler@ahsoftware.de> <CAGVrzcZd9tBtcTY_2PRHVb9kJAjVHqn+EubUy4NGL66M_UuCDg@mail.gmail.com> <533BD3CD.1010905@ahsoftware.de> <CAGVrzcZi5aNq8fR795fKhu2TAc1tQCa2YEorErZRLf2n9DPZuw@mail.gmail.com> <533C721E.1080004@gmail.com> <533C8B49.8080704@ahsoftware.de> <533C8ECB.4090900@gmail.com> <533D0B09.9040602@ahsoftware.de> <533D207E.9020909@gmail.com> <533D790C.5000104@ahsoftware.de> <533D8207.2050108@gmail.com>
In-Reply-To: <533D8207.2050108@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 03.04.2014 17:45, schrieb Sebastian Hesselbarth:

>
> I will try to reproduce it and if I hit it, will do a bisect to find
> (and fix) the offending patch.
>
>> I have better ways to waste my time.
>
> Like writing workarounds instead of fixing bugs?

Sure. If I would try to fix (or even describe) every bug in the kernel I 
already know about, I would never have time to do anything else.

Besides that you still try to ignore, that I didn't know at first that 
it's a workaround at all. Especially after I've discovered that the 
reset is the place where things are failing. Otherwise I wouldn't have 
sent the patch (which I know NOW that it just is a workaround).

Alexander Holler
