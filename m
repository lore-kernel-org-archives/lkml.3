Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab3G2FsO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 01:48:14 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:3769 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231Ab3G2FsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 01:48:12 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 28 Jul 2013 22:46:52 -0700
Message-ID: <51F604ED.5050109@nvidia.com>
Date: Mon, 29 Jul 2013 11:30:13 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Andrew Chew <achew@nvidia.com>
CC: "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        Rhyland Klein <rklein@nvidia.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] gpio: palmas: Fix misreported GPIO out value
References: <1374871193-403-1-git-send-email-achew@nvidia.com>
In-Reply-To: <1374871193-403-1-git-send-email-achew@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 27 July 2013 02:09 AM, Andrew Chew wrote:
> It seems that the value read back from the PALMAS_GPIO_DATA_IN register
> isn't valid if the GPIO direction is out.  When that's the case, we can
> read back the PALMAS_GPIO_DATA_OUT register to get the proper output value.

Looks good to me.
Acked-by: Laxman Dewangan <ldewangan@nvidia.com>

