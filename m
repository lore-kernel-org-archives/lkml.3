Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933259AbaBURl5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 12:41:57 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:33973 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687AbaBURl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 12:41:56 -0500
MIME-Version: 1.0
In-Reply-To: <20140221140958.GK5038@beef>
References: <1392941771-15774-1-git-send-email-markus.mayer@linaro.org>
	<5306DBE4.8090106@wwwdotorg.org>
	<20140221140958.GK5038@beef>
Date: Fri, 21 Feb 2014 09:41:53 -0800
Message-ID: <CAPdLdqmX7xYwHse4y9+2_-491pw0ODcjxou6_ZC9=aoiR72-MQ@mail.gmail.com>
Subject: Re: [PATCH] ARM: bcm2835: Move to mach-bcm directory
From: Markus Mayer <markus.mayer@linaro.org>
To: Matt Porter <mporter@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Christian Daudt <bcm@fixthebug.org>,
        ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 February 2014 06:09, Matt Porter <mporter@linaro.org> wrote:
> On Thu, Feb 20, 2014 at 09:53:56PM -0700, Stephen Warren wrote:
>> On 02/20/2014 05:16 PM, Markus Mayer wrote:
>> > Move the bcm2835 board file into the mach-bcm directory. This allows us
>> > to get rid of the mach-bcm2835 directory with the associated Kconfig
>> > and Makefile.
>>
>> This looks fine, although it needs a small patch to bcm2835_defconfig
>> squashed in, which I'll post in a second.
>>
>> Do you want me to take it through the bcm2835 tree? That's probably
>> easiest to avoid conflicts with any other bcm2835 patches, not that it's
>> too likely there will be any to the board file.
>
> That's ok with me. Be aware that we may have minor Kconfig/Makefile
> conflicts between the bcm2835 tree and the mach-bcm tree since we just
> queued the bcm5301x support.

Matt, will you squash Stephen's patch into mine when you take the
patches or should I submit a v2 of the patch that combines both?

-Markus


-- 
Markus Mayer
Broadcom Landing Team
