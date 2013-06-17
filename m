Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962Ab3FQPnu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 11:43:50 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:53969 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287Ab3FQPns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 11:43:48 -0400
Message-ID: <51BF2DD8.5030004@ahsoftware.de>
Date: Mon, 17 Jun 2013 17:40:08 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: rtc-linux@googlegroups.com, Andrew Morton <akpm@linux-foundation.org>,
        John Stultz <john.stultz@linaro.org>, Jingoo Han <jg1.han@samsung.com>
Subject: Re: BUG: rtc: rtc_device_unregister() broken in 3.10-rcN
References: <51BB50B1.7060308@ahsoftware.de>
In-Reply-To: <51BB50B1.7060308@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 14.06.2013 19:19, schrieb Alexander Holler:
> Hello,
>
> I've just tested some things with 3.10-rc5+ and discovered that
> rtc_device_unregister is broken. This is most likely because of the
> switch to devm*. As 3.10 is already at -rc5, I'm posting this without

Just in case the question arises, this worked and works perfectly with 
3.9.x, so maybe I should have named it REGRESSION rather than BUG.

Regards,

Alexander

PS: I changed typo in the subject from rtc_unregister_device to 
rtc_device_unregister
