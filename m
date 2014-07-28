Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590AbaG1Lia (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 07:38:30 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:50689 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982AbaG1Li1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 07:38:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Benoit Masson <benoitm@perenite.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Benoit Masson <yahoo@perenite.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jason@lakedaemon.net, gregory.clement@free-electrons.com,
        sebastian.hesselbarth@googlemail.com
Subject: Re: [PATCH 2/2] ARM: mvebu: Added dts defintion for Lenovo Iomega ix4-300d NAS
Date: Mon, 28 Jul 2014 13:37:32 +0200
Message-ID: <9654351.pgAIO1YYYY@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <78E68BC6-1D2C-4B75-93BA-5414A358B90D@perenite.com>
References: <1406418436-61452-1-git-send-email-yahoo@perenite.com> <6028388.mjACYPxFta@wuerfel> <78E68BC6-1D2C-4B75-93BA-5414A358B90D@perenite.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:P1avXcVlS3Pdxxadz/fJmcVm+i32eyRFj8Zc5/7OwuW
 /m8F6hPs5N5Yl4b+wOLnianp7y+/QAwDuff9R+28uhQVK6PgxX
 mLtMtVYyxwmLAcvxqo3WQ5DfzYVH0nkUHgANyl7f9kizUvv+8t
 O82kHIjwRXEV//28+VhUedP9zof8hxQXFk8p6shFBjgIb8IAL2
 tDFcud0k+nrkWD/8blZS2f1eRfh5SHaeCqejrv2ynq49K6k+KQ
 3ghzCwCgLq6q4FpW2XvoHFxain2Upl3X+PSaAq3u8e9FyJHoJX
 PQwSgURwvfOHgHv1QkTLrrw6Y2G/jVA1GBkI8w8dd5gytaQHPD
 3b2muNve99GfT00nkmeA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 July 2014 13:17:56 Benoit Masson wrote:
> 
> Ok then does this mean I can simply remove the "compatible" line to only inherits from armada-xp-dtsi ?
> 
> "i2c@11000 {
>                                 clock-frequency = <400000>;
>                                 status = "okay";
> "
> 
> Would this be enough ?

Yes, this looks ideal.

	Arnd
