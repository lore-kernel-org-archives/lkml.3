Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448AbaIISTf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 14:19:35 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:54642 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbaIISTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 14:19:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alban Bedel <alban.bedel@avionic-design.de>
Cc: Thierry Reding <thierry.reding@gmail.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-pwm@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>, Roland Stigge <stigge@antcom.de>
Subject: Re: [PATCH V3] pwm: lpc32xx - Add a driver for the motor PWM
Date: Tue, 09 Sep 2014 20:19:25 +0200
Message-ID: <79685201.RtYEqhYoTB@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140909180530.635ce6f7@avionic-0020>
References: <1410277361-26848-1-git-send-email-alban.bedel@avionic-design.de> <2942175.JkZcLDKfiR@wuerfel> <20140909180530.635ce6f7@avionic-0020>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:296gSYSC5BpGiWUhi3FdK8mjDlGulYsfmnyii3+xxTj
 AgQ42/T3miXgLGCiwUDJcU9ZqwZU9f87L3jkchRx1TGNz/rbYd
 c1pnWfCQzSVnJZDEQp1oTqW9QgKibBWehARvE2ate32XqWNqM1
 0Txg6QVF6U4ECIMigjtcoWiG/4BqUQpZNlnb1r22WYnR4rq2o1
 DxNg0rQ2odOOuJqYHSrDk3GI+qKK7LtY9peotqfZnH8nXGrAg0
 3NEfX2cKyqnk0evU4Fqbmc0+pNBXpYfql0mg2UqaeYYeAOj7bn
 2AVSYXS80cCoubJsjxnuP5xS6mrmaNcNiElTJM/ajVEmf/UQiZ
 OGVFS5SF78khwUqTx05U=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 September 2014 18:05:30 Alban Bedel wrote:
> 
> I'll add COMPILE_TEST, PWM is already there because this is in an if
> PWM block. However I'm not sure for the clk, the LPC32xx use its own
> implementation of the clk functions, what should I add in this case?

You can add a dependency on CLKDEV_LOOKUP, which is set by both LPC32xx
and by COMMON_CLK.

	Arnd
