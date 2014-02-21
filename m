Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933459AbaBURsj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 12:48:39 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:39506 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933011AbaBURsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 12:48:38 -0500
Message-ID: <53079173.3030305@wwwdotorg.org>
Date: Fri, 21 Feb 2014 10:48:35 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Markus Mayer <markus.mayer@linaro.org>, Matt Porter <mporter@linaro.org>
CC: Christian Daudt <bcm@fixthebug.org>,
        ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: bcm2835: Move to mach-bcm directory
References: <1392941771-15774-1-git-send-email-markus.mayer@linaro.org>	<5306DBE4.8090106@wwwdotorg.org>	<20140221140958.GK5038@beef> <CAPdLdqmX7xYwHse4y9+2_-491pw0ODcjxou6_ZC9=aoiR72-MQ@mail.gmail.com>
In-Reply-To: <CAPdLdqmX7xYwHse4y9+2_-491pw0ODcjxou6_ZC9=aoiR72-MQ@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2014 10:41 AM, Markus Mayer wrote:
> On 21 February 2014 06:09, Matt Porter <mporter@linaro.org> wrote:
>> On Thu, Feb 20, 2014 at 09:53:56PM -0700, Stephen Warren wrote:
>>> On 02/20/2014 05:16 PM, Markus Mayer wrote:
>>>> Move the bcm2835 board file into the mach-bcm directory. This allows us
>>>> to get rid of the mach-bcm2835 directory with the associated Kconfig
>>>> and Makefile.
>>>
>>> This looks fine, although it needs a small patch to bcm2835_defconfig
>>> squashed in, which I'll post in a second.
>>>
>>> Do you want me to take it through the bcm2835 tree? That's probably
>>> easiest to avoid conflicts with any other bcm2835 patches, not that it's
>>> too likely there will be any to the board file.
>>
>> That's ok with me. Be aware that we may have minor Kconfig/Makefile
>> conflicts between the bcm2835 tree and the mach-bcm tree since we just
>> queued the bcm5301x support.
> 
> Matt, will you squash Stephen's patch into mine when you take the
> patches or should I submit a v2 of the patch that combines both?

I think Matt said it was OK to take them through the bcm2835 tree. I'll
squash them together; no need to repost.
