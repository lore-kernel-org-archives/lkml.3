Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499AbaLANUF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 08:20:05 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.140]:44067 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752934AbaLANUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 08:20:03 -0500
Message-ID: <547C6AE0.80808@arm.com>
Date: Mon, 01 Dec 2014 13:19:28 +0000
From: Andrew Jackson <Andrew.Jackson@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Dave Airlie <airlied@gmail.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] drm: i2c: tda998x: Retry fetching the EDID if it fails
 first time.
References: <546B84C6.3090809@arm.com>	<20141128091905.3e491c39@armhf>	<54783A2F.5010405@arm.com> <20141129114102.02366857@armhf>
In-Reply-To: <20141129114102.02366857@armhf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/14 10:41, Jean-Francois Moine wrote:
> On Fri, 28 Nov 2014 09:02:39 +0000
> Andrew Jackson <Andrew.Jackson@arm.com> wrote:
> 
>>> It seems that your patch is deprecated by Laurent Pinchart's
>>> 	[PATCH] drm: tda998x: Use drm_do_get_edid()
>>> http://lists.freedesktop.org/archives/dri-devel/2014-November/072906.html
>>>   
>>
>> Thank you for the heads-up, I'd not seen that.  I'll consider how my patch might be modified to suit the new infrastructure.
> 
> You don't need any patch: drm_do_get_edid() already loops on reading
> the EDID.
> 

Thank you again: that saves me work!

   Andrew
