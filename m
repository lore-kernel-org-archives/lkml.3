Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab3DVHDV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 03:03:21 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:64792 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138Ab3DVHDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 03:03:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCH 2/5] driver core: move to_platform_driver to platform_device.h
Date: Mon, 22 Apr 2013 09:03:07 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
References: <1366596798-9457-1-git-send-email-robherring2@gmail.com> <1366596798-9457-3-git-send-email-robherring2@gmail.com>
In-Reply-To: <1366596798-9457-3-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304220903.07824.arnd@arndb.de>
X-Provags-ID: V02:K0:lLLPhiSvJTTjzw17tLQGN4yMrI1XE4nk6xHqgkfOPkZ
 02jx4RqP2290iY35gXuYCPzn6KMb33hs4UVRa75bvObLuR8pk4
 NoMbPsl033kOnbp7cSJ7SalrMXu8+f6D+CPM6k/uMGYEU4UC6o
 NWWh7/UeX8myPgjnijUxAIdyVWMQSMvRs7IgfPCqGX9A8T6eGj
 IRJ+jS4ejDPSCogpuvSUCkosOkmQMymbs+DP6ZTxCjZ44RLbo1
 NCmEAXbTwx59HTUCT8PtiiwKBF4nzvr6DF2hzkCWPSjnM60xsY
 pzVPCBvQzJOSntZZa2+XUg8eCAeRQP6MiYLk4bOKkeevRvB3ql
 d53j9Dk6mYIDVZKbi0QY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 April 2013, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> In converting the last remaining of_platform_driver (ibmebus) to a regular
> platform driver, to_platform_driver is needed to replace
> to_of_platform_driver.
> 
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Grant Likely <grant.likely@linaro.org>

It sounds like this patch is needed first, so you should swap the first
two patches in the series.

	Arnd
