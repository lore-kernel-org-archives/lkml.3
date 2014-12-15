Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751600AbaLOQ16 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 11:27:58 -0500
Received: from smtp08.smtpout.orange.fr ([80.12.242.130]:26830 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbaLOQ14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 11:27:56 -0500
X-ME-Helo: beldin
X-ME-Date: Mon, 15 Dec 2014 17:27:54 +0100
X-ME-IP: 86.199.199.51
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH] mfd: cottula: add cottula board
References: <1418598606-21352-1-git-send-email-robert.jarzmik@free.fr>
	<4307800.p21Sk5E3dV@wuerfel> <877fxsapds.fsf@free.fr>
	<2126713.SdhEsThCG0@wuerfel>
X-URL: http://belgarath.falguerolles.org/
Date: Mon, 15 Dec 2014 17:27:53 +0100
In-Reply-To: <2126713.SdhEsThCG0@wuerfel> (Arnd Bergmann's message of "Mon, 15
	Dec 2014 17:01:14 +0100")
Message-ID: <87388ganee.fsf@free.fr>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> writes:

>> Will that look correct ?
>
> I'd still prefer the platform data, but this seems good enough and I
> see no serious problems with it.
OK, so I'll try with the 2 resources. If I'm bitten afterwards and am forced to
have a platform data, you'll tell me "I had warned you" ;)

I'll let a couple of days before patch v2 to gather more reviews.

Thanks.

-- 
Robert
