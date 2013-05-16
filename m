Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab3EPNKj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 09:10:39 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:34707 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753074Ab3EPNKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 09:10:38 -0400
Message-ID: <5194DAC5.9080203@ti.com>
Date: Thu, 16 May 2013 15:10:29 +0200
From: =?UTF-8?B?VmluY2VudCBTdGVobMOp?= <v-stehle@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: =?UTF-8?B?VmluY2VudCBTdGVobMOp?= <vincent.stehle@laposte.net>,
        Tony Lindgren <tony@atomide.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: OMAP5: select SCU
References: <1368550638-2046-1-git-send-email-vincent.stehle@laposte.net> <51938169.4060109@ti.com>
In-Reply-To: <51938169.4060109@ti.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2013 02:36 PM, Santosh Shilimkar wrote:
> OMAP5 doesn't need the SCU. So Nak for the patch.

Hi,

I agree that it is a pure link issue.

> I haven't noticed
> this earlier. Do you know which commit broke this ?

After some bisecting I arrived at this merge commit:

  5497e7b Merge branch 'late/fixes' into fixes

Indeed, if I revert it (-m 1) the result does link properly. I'll try to
isolate it further.

Best regards,

V.

