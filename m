Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086AbaLDM1s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 07:27:48 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:36660 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946AbaLDM1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 07:27:46 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Date: Thu, 04 Dec 2014 13:29:58 +0100
From: Stefan Agner <stefan@agner.ch>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: Sanchayan Maity <maitysanchayan@gmail.com>, rtc-linux@googlegroups.com,
        shawn.guo@linaro.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Subject: Re: [RESEND PATCHv2] drivers/rtc/rtc-snvs: Add clock support
In-Reply-To: <20141204110551.0837304e@linux.lan.towertech.it>
References: <cover.1417585458.git.maitysanchayan@gmail.com>
 <bf8571fc7474877be39a5a4e9d4705358e63d840.1417585458.git.maitysanchayan@gmail.com>
 <20141204110551.0837304e@linux.lan.towertech.it>
Message-ID: <c83ddb993eb36fa1444aba0d4ff717a6@agner.ch>
User-Agent: Roundcube Webmail/1.0.3
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Thu Dec  4 13:27:06 2014
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5480531a12812058618465
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-12-04 11:05, Alessandro Zummo wrote:
> On Wed,  3 Dec 2014 11:28:55 +0530
> Sanchayan Maity <maitysanchayan@gmail.com> wrote:
> 
>> The clock is not strictly enforced, as this would
>> break the i.MX devices. The clocking for the i.MX
>> devices seems to be enabled elsewhere and enabling
>> RTC SNVS for Vybrid results in a crash. This patch
>> adds the clock support but also makes it optional
>> so Vybrid platform can use the clock if defined
>> while making sure not to break i.MX .
>>
>> Signed-off-by: Sanchayan Maity <maitysanchayan@gmail.com>
> 
> 
>  Acked-by: Alessandro Zummo <a.zummo@towertech.it>

Through which tree is this going upstream?

--
Stefan

