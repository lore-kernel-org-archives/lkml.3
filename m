Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760224AbaGSJDg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 05:03:36 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:45021 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757620AbaGSJDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 05:03:34 -0400
Message-ID: <53CA346B.1050802@gmail.com>
Date: Sat, 19 Jul 2014 11:03:39 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
To: Tejun Heo <tj@kernel.org>,
        =?ISO-8859-1?Q?Antoine_T=E9nart?= 
	<antoine.tenart@free-electrons.com>
CC: kishon@ti.com, alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-ide@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH v10 0/8] ARM: berlin: add AHCI support
References: <1405686607-8126-1-git-send-email-antoine.tenart@free-electrons.com> <20140718135758.GB13012@htj.dyndns.org>
In-Reply-To: <20140718135758.GB13012@htj.dyndns.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2014 03:57 PM, Tejun Heo wrote:
> On Fri, Jul 18, 2014 at 02:29:59PM +0200, Antoine Ténart wrote:
>> In both cases we do not have time to do this for the next release, as
>> the request popped up quite late.
>>
>> So as of now:
>>   - Either the series is merged as is and changes to the AHCI framework
>>     can be made for 3.18, as it's not particularly linked to this
>>     series.
>>   - Or you really do not want it. Then that would be great if patches
>>     1-2 and 7-8 could be merged so that we do not end up with this big
>>     series going for yet another cycle... I think Kishon already took
>>     patches 1-2.
> 
> I don't wanna take in code which isn't in the shape that it should be.
> Things like this accumulate to become a large maintenance burden over
> time.  Sure, urgent things can slip in and then later be fixed up but
> who are gonna do that here?  You guys already seem to be under time
> pressure as it is.
> 
> If you guys can figure something out with Hans regarding how to
> proceed on this, I'll be happy take the code as is.

I cannot say much about AHCI, but if the PHY driver is fine I can
take the DT patches adding it to BG2Q and BG2Q-DMP at any time.

Sebastian

