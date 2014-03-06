Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730AbaCFVMG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 16:12:06 -0500
Received: from nm17-vm1.bullet.mail.bf1.yahoo.com ([98.139.213.55]:32976 "EHLO
	nm17-vm1.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753705AbaCFVMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 16:12:03 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Mar 2014 16:12:03 EST
X-Yahoo-Newman-Id: 831957.37080.bm@smtp214.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: aIMk.w4VM1nam37bQY6aVLTuW0x9w81OWO0x192mceW6ayV
 gWio7RlqEKOktHdrjbQVvIu9ixSpGrd1WULLJqw2UN3PpGUykjA_Ecllo1nL
 hr3OkaludgjUG4XE4UDDbYd2LPdDdUDPCmpSvmCCo7eb0hOrS0oL93h75Mtt
 6YGgb4W5YVxVsGU..kbOaGsFp2Ykamc1mQocO8f96Yowk0YKlNoe_UiG.1r6
 mOijg15hWooNXG7SVT5pLzMHTpa6yYhkb8v8NE822izkLMQwb.KA2eNrd4X7
 Hyu5806Z3UV2xEcRw9pA1_cP6txGV5jM3bwAb2vLL_mf9h0hbibwcPzlvGMT
 zqIZuRdsK_vrQS8i5woWt5.2A5Njmocj0wtGlldsUD962JNFo7F08vqdPN26
 G8vm8emG_8VHZAks3ABt5cV8MGiF6AoHqkIS7OgXPEPO8_6VxinN1py.mq_e
 v2SPWbPuPd076UN6PiE3SFgBDI7EkDBlhvQvPO5O_cC7QPADZmLARr5MIaG9
 Gzv0Qnz7SPNPBuyZAA97mKlnMadlxXbMW2z9d3uK56aFPxL8R_CT6C9vUffD
 m7lNxih4NjZZSUgWoT08rWjlBpprcAcEhjezTSJeHF4e5WVR.Jfxa1P4YlxO
 N1K2DZp6i8EGe1cpTQuqAxl.IYCKoxo4yAS62QXBELEdgmNwviciCFhs-
X-Yahoo-SMTP: u9r3j8eswBBsV5z1r5v0bR9cjPS77vatbJK.6sw-
X-Rocket-Received: from [163.238.113.35] (draconicpenguin1@163.238.113.35 with plain [98.139.211.125])
        by smtp214.mail.bf1.yahoo.com with SMTP; 06 Mar 2014 13:05:21 -0800 PST
Message-ID: <5318E311.8000303@yahoo.com>
Date: Thu, 06 Mar 2014 16:05:21 -0500
From: Brian Wong <draconicpenguin1@yahoo.com>
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: KY Srinivasan <kys@microsoft.com>, linux-kernel@vger.kernel.org
Subject: Re: Hyper-V Synthetic Video Frame Buffer Driver may distort top two
 lines of console
References: <5318DD7A.2080706@yahoo.com>
In-Reply-To: <5318DD7A.2080706@yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/6/2014 3:41 PM, Brian Wong wrote:
> I've identified another possible bug in the Hyper-V drivers: When the
> Hyper-V Synthetic Video Frame Buffer Driver is built into the kernel,
> and the VM is paused and continued, the top two lines of the console may
> become distorted. See the image at http://imgur.com/kIExFP3.
>
> Can someone look into it?

Just to clarify, I can confirm this bug under both the patched Gentoo 
3.10.32 kernel and the vanilla 3.13.5 kernel (see the image at 
http://imgur.com/mYUTzgt). Is the framebuffer somehow getting corrupted?

-- 
Brian Wong
http://www.fierydragonlord.com
