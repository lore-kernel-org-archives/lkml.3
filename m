Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775AbbALOZJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 09:25:09 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:53572 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbbALOZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 09:25:06 -0500
Message-ID: <54B3D8F9.9030003@roeck-us.net>
Date: Mon, 12 Jan 2015 06:23:53 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Bartosz Golaszewski <bgolaszewski@baylibre.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        LM Sensors <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH 0/2] hwmon: (ina2xx) code clean-up and minor fixes
References: <1421070442-9635-1-git-send-email-bgolaszewski@baylibre.com>
In-Reply-To: <1421070442-9635-1-git-send-email-bgolaszewski@baylibre.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020205.54B3D942.0010,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 4
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2015 05:47 AM, Bartosz Golaszewski wrote:
> This small series fixes two minor issues in the driver after recent
> implementation of new attributes. The first patch removes an unnecessary
> result check after calling dev_get_drvdata() and the second one adds
> calls to DIV_ROUND_CLOSEST() to avoid rounding errors.
>
> This series is rebased against current hwmon-next.
>
> Bartosz Golaszewski (2):
>    hwmon: (ina2xx) remove an unnecessary dev_get_drvdata() result check
>    hwmon: (ina2xx) use DIV_ROUND_CLOSEST() to avoid rounding errors
>
Both applied to -next.

Thanks,
Guenter


