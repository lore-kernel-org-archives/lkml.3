Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574AbaABS3y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 13:29:54 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:55511 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbaABS3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 13:29:53 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 01/17] ARM: spear: Remove deprecated IRQF_DISABLED flag
Date: Thu, 2 Jan 2014 19:29:46 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>, olof@lixom.net,
        khilman@linaro.org, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
References: <1388419771-30075-1-git-send-email-daniel.lezcano@linaro.org>
In-Reply-To: <1388419771-30075-1-git-send-email-daniel.lezcano@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201401021929.46581.arnd@arndb.de>
X-Provags-ID: V02:K0:swJLU1/2vwTFw7e/TotZmO8xwcjq36AIa/OfJIDENor
 Y1uZKwh+A8TBFCr2FCVAs5BiZ2IPIox4xQRMJF/La0BMpKQlRD
 js7iMX2z6d5oJHfIR+GxpbdJqcpzyu+vclCiY7RrpLSzyQp18l
 amRdLkqIu06YTk9aBpxd+QByqy0r55h1TIpQwibBVBksS6COBC
 gFKg6KjjTEemfrkrxwf41jEyaPaqxMRtmk2dwUEmU4DO5S8C+L
 fzO01VyHPeIqHazNpZ+DtTt2h6Id2Yr10WJ/PPRM3dldE2sw8P
 ntwWMjtv+HcJCg5c/m08WoL9821HnrPH3fYOCy1yafAUzooXZJ
 lNNOM1Cgd4qcBUm8AhwE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 December 2013, Daniel Lezcano wrote:
> This flag is a NOOP and scheduled to be removed
> 
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>

Thanks for sending this series. I think the patches are duplicates of stuff that
Michael Opdenacker has sent before (actually multiple times). I have no problem
applying either version into arm-soc, but I think it would be better to attribute
them to Michael, since he came first. Can you two please coordinate and send a
single pull request for the arm-soc related patches that haven't made it into
linux-next yet?

	Arnd
