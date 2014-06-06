Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133AbaFFQGc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 12:06:32 -0400
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:36814 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751660AbaFFQGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 12:06:31 -0400
Message-ID: <5391E6FE.1060901@codethink.co.uk>
Date: Fri, 06 Jun 2014 17:06:22 +0100
From: Ben Dooks <ben.dooks@codethink.co.uk>
Organization: Codethink Limited.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Ian Molton <ian.molton@codethink.co.uk>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        William Towle <william.towle@codethink.co.uk>
Subject: Re: [GIT PULL for 3.16-rc1] updates and DT support for adv7604
References: <20140605095535.7753cb6b.m.chehab@samsung.com> <5391E304.6030008@codethink.co.uk> <5391E39F.1030402@metafoo.de>
In-Reply-To: <5391E39F.1030402@metafoo.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/14 16:51, Lars-Peter Clausen wrote:
> On 06/06/2014 05:49 PM, Ben Dooks wrote:
>> On 05/06/14 13:55, Mauro Carvalho Chehab wrote:
>>> Linus,
>>>
>>> Please pull from:
>>>    git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media
>>> topic/adv76xx
>>>
>>> For adv7604 driver updates, including DT support.
>>
>> Can we use the adv7611 for the adv7612 with these?
>>
> 
> You can, except that you won't be able to use the second HDMI in. But it
> should be fairly trivial to add that.

Thanks, we're going to try the rcar_vin driver and the HDMI in on the
Lager board next week.

-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius
