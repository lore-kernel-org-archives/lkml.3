Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbaETRgF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 13:36:05 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:34348 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbaETRgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 13:36:03 -0400
Message-ID: <537B927F.4070504@wwwdotorg.org>
Date: Tue, 20 May 2014 11:35:59 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Doug Anderson <dianders@chromium.org>, wsa@the-dreams.de,
        abrestic@chromium.org, dgreid@chromium.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 6/7] i2c: ChromeOS EC tunnel driver
References: <1398879850-9111-1-git-send-email-dianders@chromium.org> <1398879850-9111-7-git-send-email-dianders@chromium.org> <20140520084702.GG24991@lee--X1>
In-Reply-To: <20140520084702.GG24991@lee--X1>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2014 02:47 AM, Lee Jones wrote:
> On Wed, 30 Apr 2014, Doug Anderson wrote:
> 
>> On ARM Chromebooks we have a few devices that are accessed by both the
>> AP (the main "Application Processor") and the EC (the Embedded
>> Controller).  These are:
>> * The battery (sbs-battery).
>> * The power management unit tps65090.
>>
>> On the original Samsung ARM Chromebook these devices were on an I2C
>> bus that was shared between the AP and the EC and arbitrated using
>> some extranal GPIOs (see i2c-arb-gpio-challenge).
...
> Applied, thanks.

Was the branch pushed too? I can't see these patches at
git://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd.git for-mfd-next
(or master or for-mfd-fixes)
