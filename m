Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409AbaDDOOJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 10:14:09 -0400
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:63529 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752989AbaDDOOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 10:14:08 -0400
Message-ID: <1396620845.19661.14.camel@x220>
Subject: Re: [PATCH] arm: Fix DEBUG_LL for multi-platform kernels (without
 PL01X)
From: Paul Bolle <pebolle@tiscali.nl>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linaro-kernel@lists.linaro.org,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, patches@linaro.org,
        spear-devel@list.st.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Date: Fri, 04 Apr 2014 16:14:05 +0200
In-Reply-To: <8799740.0uZJLUBGY1@wuerfel>
References: <1396610269-11580-1-git-send-email-daniel.thompson@linaro.org>
	 <8799740.0uZJLUBGY1@wuerfel>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Apr 2014 14:14:06.0511 (UTC) FILETIME=[23AA83F0:01CF5010]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-04-04 at 13:39 +0200, Arnd Bergmann wrote:
> The PLAT_SPEAR_SINGLE symbol in Kconfig
> is a leftover from an earlier patch I did that never got merged,
> and we should just remove that.

Correct, see http://thread.gmane.org/gmane.linux.kernel/1646112 . It
seems nothing happened after that. I'm planning on sending a reminder if
PLAT_SPEAR_SINGLE is still mentioned in v3.15-rc1.


Paul Bolle

