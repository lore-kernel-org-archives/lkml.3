Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009AbbATKle (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:41:34 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:46680 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480AbbATKla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:41:30 -0500
From: Peter Korsgaard <peter@korsgaard.com>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: "linux-gpio\@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Peter Korsgaard <jacmet@sunsite.dk>,
        "devicetree\@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 7/8] gpio/mpc8xxx: Convert to platform device interface.
References: <1421581173-28416-1-git-send-email-ricardo.ribalda@gmail.com>
	<1421581173-28416-8-git-send-email-ricardo.ribalda@gmail.com>
	<87k30i9ykv.fsf@dell.be.48ers.dk>
	<CAPybu_180vMPMx4yhFAoL9H2b34+tWtqQCTHjxqkTRt9e_VA5g@mail.gmail.com>
Date: Tue, 20 Jan 2015 11:41:27 +0100
In-Reply-To: <CAPybu_180vMPMx4yhFAoL9H2b34+tWtqQCTHjxqkTRt9e_VA5g@mail.gmail.com>
	(Ricardo Ribalda Delgado's message of "Tue, 20 Jan 2015 00:37:07
	+0100")
Message-ID: <8761c191k8.fsf@dell.be.48ers.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Ricardo" == Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com> writes:

 > Hello Peter
 > I thought the logic behind the original driver was:

 > 1) Create gpiochip so it can be used by other modules/userland
 > 2) if there is also a irq available for it, create a irqdomain.
 > otherwise continue.

Indeed - Sorry, I must have been confused yesterday.

-- 
Bye, Peter Korsgaard
