Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030218Ab3BGTGS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 14:06:18 -0500
Received: from quechua.inka.de ([193.197.184.2]:54928 "EHLO mail.inka.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758580Ab3BGTGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 14:06:16 -0500
X-Greylist: delayed 1309 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Feb 2013 14:06:16 EST
Date: Thu, 07 Feb 2013 19:44:18 +0100
To: linux-kernel@vger.kernel.org
Subject: Re: MODSIGN without RTC?
References: <5112EA69.6010100@ahsoftware.de> <5112FE21.4020404@ahsoftware.de>
Organization: private Linux site, southern Germany
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
From: Olaf Titz <olaf@bigred.inka.de>
Message-ID: <E1U3WSI-00023L-QG@bigred.inka.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Another option would be to make a configure option to just ignore the
> date. I'm not sure if I would like to use MODSIGN when I have to fear
> that the machine wouldn't start when the RTC fails or got set to a wrong
> date.

Or just ignore the date unconditionally. After all, when a certificate
check fails due to out-of-validity-period, then you can always "fix"
that by appropriately setting the clock. So for security, in this
application, the date check is outright useless.

Olaf
