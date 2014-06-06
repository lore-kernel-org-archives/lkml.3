Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413AbaFFPwG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 11:52:06 -0400
Received: from smtp-out-004.synserver.de ([212.40.185.4]:1043 "EHLO
	smtp-out-004.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371AbaFFPwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 11:52:04 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 10154
Message-ID: <5391E39F.1030402@metafoo.de>
Date: Fri, 06 Jun 2014 17:51:59 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Ben Dooks <ben.dooks@codethink.co.uk>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Ian Molton <ian.molton@codethink.co.uk>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        William Towle <william.towle@codethink.co.uk>
Subject: Re: [GIT PULL for 3.16-rc1] updates and DT support for adv7604
References: <20140605095535.7753cb6b.m.chehab@samsung.com> <5391E304.6030008@codethink.co.uk>
In-Reply-To: <5391E304.6030008@codethink.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2014 05:49 PM, Ben Dooks wrote:
> On 05/06/14 13:55, Mauro Carvalho Chehab wrote:
>> Linus,
>>
>> Please pull from:
>>    git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media topic/adv76xx
>>
>> For adv7604 driver updates, including DT support.
>
> Can we use the adv7611 for the adv7612 with these?
>

You can, except that you won't be able to use the second HDMI in. But it 
should be fairly trivial to add that.

- Lars
