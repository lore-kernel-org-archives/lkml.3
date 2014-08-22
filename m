Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291AbaHVPpn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 11:45:43 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:55505 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098AbaHVPpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 11:45:42 -0400
Message-ID: <53F7657D.2060304@ahsoftware.de>
Date: Fri, 22 Aug 2014 17:45:01 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: Thierry Reding <thierry.reding@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Jon Loeliger <jdl@jdl.com>, Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 0/9] dt: dependencies (for deterministic driver initialization
 order based on the DT)
References: <1399913280-6915-1-git-send-email-holler@ahsoftware.de> <20140514141914.446F7C4153D@trevor.secretlab.ca> <20140821140211.GD19293@ulmo.nvidia.com> <53F64624.5000403@ahsoftware.de> <20140822131919.GX21734@leverpostej>
In-Reply-To: <20140822131919.GX21734@leverpostej>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 22.08.2014 15:19, schrieb Mark Rutland:
> On Thu, Aug 21, 2014 at 08:19:00PM +0100, Alexander Holler wrote:
>> Am 21.08.2014 16:02, schrieb Thierry Reding:
>>
>>> Anyway, those are all fairly standard reasons for where deferred probe
>>> triggers, and since I do like deferred probe for it's simplicity and
>>> reliability I'd rather not try to work around it if boot time is all
>>> that people are concerned about.
>>
>> It's neither simple nor reliable. It's non deterministic brutforcing
>> while making it almost impossible to identify real errors.
>
> It's horrible, yes.
>
>> In my humble opinion the worst way to solve something. I'm pretty sure
>> if I would have suggest such a solution, the maintainer crowd would have
>> eaten me without cooking.
>
> We didn't have a better workable solution at the time. Having a hack
> that got boards booting was considered better than not having them boot.
> I don't remember people being particularly enthralled by the idea.

Agreed. And usually I don't flame about workarounds. They are needed 
practice usually born out of a time limited background or similiar 
constraints.

Only Linux kernel maintainers do demand perfect stuff from others as the 
kernel seems to have to be a perfect school project. I for myself 
already think checkpatch is a ridiculous tool, only invented to drive 
people crazy. Of course, it's better a tool drives people crazy than a 
maintainer who make decisions based on the phase of the moon, but ... ;)

And I haven't flamed much about deferred probe before, but if I read 
it's simple and reliable I couldn't stand still.

Sorry,

Alexander Holler


