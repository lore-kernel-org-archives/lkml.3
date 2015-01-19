Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751780AbbASTCO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 14:02:14 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:63024 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbbASTCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 14:02:11 -0500
Date: Mon, 19 Jan 2015 20:01:20 +0100 (CET)
From: Stefan Wahren <stefan.wahren@i2se.com>
Reply-To: Stefan Wahren <stefan.wahren@i2se.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-kernel@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, lee@kernel.org, pawel.moll@arm.com,
        linux@arm.linux.org.uk, robh+dt@kernel.org,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        mark.rutland@arm.com
Message-ID: <1722146904.386302.1421694080817.JavaMail.open-xchange@oxbaltgw08.schlund.de>
In-Reply-To: <54BD3B49.4050203@wwwdotorg.org>
References: <1421665231-28221-1-git-send-email-stefan.wahren@i2se.com> <54BD3B49.4050203@wwwdotorg.org>
Subject: Re: [PATCH 2/4 V2] dt-bindings: Add root properties for Raspberry
 Pi
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.6.0-Rev36
X-Originating-Client: com.openexchange.ox.gui.dhtml
X-Provags-ID: V03:K0:or7Y0lznDVS4jLmDk6qFUAK7t825mNubDf9GLcZ8nuAe2/8/qnq
 jK77engJJITq4PfEPWx/ac0BmyeE70WrxCUeNpD0k+zJ5RG+Q40/mRXG7nTBeTMnqAJNWqJ
 anUXBxtknJQNftUvoHpDBiMQRPnoYEtW8SrhwTWdauf/IYGQOody8wQUN9TPBRSnwNuyZ3O
 6UT/ytWCwpcyHcxkwUkNA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

> Stephen Warren <swarren@wwwdotorg.org> hat am 19. Januar 2015 um 18:13
> geschrieben:
>
>
> On 01/19/2015 04:00 AM, Stefan Wahren wrote:
> > This patch adds root compatible properties for the following boards:
> > - Raspberry Pi Model A
> > - Raspberry Pi Model A+
> > - Raspberry Pi Model B
> > - Raspberry Pi Model B (no P5)
> > - Raspberry Pi Model B rev2
> > - Raspberry Pi Model B+
> > - Raspberry Pi Compute Module
>
> Acked-by: Stephen Warren <swarren@wwwdotorg.org>
>
> This seems sane to me. One thing I should have asked: What compatible
> values does the RPi Foundation's downstream for all these cases?

good point. Unfortunately my patches to linux-rpi-kernel are held back because
of too many recipients, so it's possible that someone complain later.

I have looked at chapter 3.1 in [1], but didn't find the any other variants than
B and B+:

  Here, the presence or absence of the "-plus" is the significant thing, not the
"b" -- Model A's and A+'s will 
  use the "b" and "b-plus" variants, respectively.

Also in the newest branch [2]:

bcm2835-rpi-b.dts      -> model = Raspberry Pi Model B
bcm2708-rpi-b.dts      -> model = Raspberry Pi Model B
bcm2708-rpi-b-plus.dts -> model = Raspberry Pi Model B+

Sorry, i don't have any experience with the downstream kernel. So please correct
me if looked at the wrong places.

[1] -
https://github.com/raspberrypi/documentation/blob/master/configuration/device-tree.md
[2] - https://github.com/raspberrypi/linux/tree/rpi-3.18.y/

> Aligning with that would be nice if possible.

Stefan
