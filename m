Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528AbaIJPwA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 11:52:00 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:53088 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbaIJPv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 11:51:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alban Bedel <alban.bedel@avionic-design.de>
Cc: Thierry Reding <thierry.reding@gmail.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-pwm@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>, Roland Stigge <stigge@antcom.de>
Subject: Re: [PATCH V4] pwm: lpc32xx - Add a driver for the motor PWM
Date: Wed, 10 Sep 2014 17:51:36 +0200
Message-ID: <12709842.iga6ki5KTS@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1410363822-22151-1-git-send-email-alban.bedel@avionic-design.de>
References: <1410363822-22151-1-git-send-email-alban.bedel@avionic-design.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:cPL8SRMjiivjMoW2MHC0pE+klhpFSg/36QRjdyeFG6z
 oWpeV5tctHxYHvy7G8oKGe4gb1fN0cKcNo5EYlNcfndB4slepC
 23VJLYL61547ys0r45cLJKn+wVxy7pq0ebF5FloLLnVfakFsyJ
 3ST35I50rau/rP8Rrpn3JCYNOEoNBMVbAbr7CLA1mC5w0+bIp3
 BfW7P5n3GFl2QUJLRKyxOxH25FT7kDneFZwM0L4p9RRllQEqC2
 m7VkgkwjVg1aoNt9gATApB4MZJ5vSmEXwfP3UnRU6kr4QlbSvv
 DTuwD30b2CYgRb5Rm0nZAH1JCAX+sdFLmjl96gSCR7DDir+D7t
 uA9Csa17RlGv5Y5TH1hQ=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 September 2014 17:43:42 Alban Bedel wrote:
> +- #pwm-cells: should be 3. See pwm.txt in this directory for a description of
> +  the cells format. The only third cell flag supported by this binding is
> +  PWM_POLARITY_INVERTED.

If you don't have multiple pwm outputs or programmable period, I would say it
should use #pwm-cells=<1> and only pass the polarity.

	Arnd
