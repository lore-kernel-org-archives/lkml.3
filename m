Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751540AbaK1Jw7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 04:52:59 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.140]:36080 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750994AbaK1Jw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 04:52:56 -0500
X-Greylist: delayed 2974 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Nov 2014 04:52:55 EST
Message-ID: <54783A2F.5010405@arm.com>
Date: Fri, 28 Nov 2014 09:02:39 +0000
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
References: <546B84C6.3090809@arm.com> <20141128091905.3e491c39@armhf>
In-Reply-To: <20141128091905.3e491c39@armhf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/14 08:19, Jean-Francois Moine wrote:
> On Tue, 18 Nov 2014 17:41:26 +0000
> Andrew Jackson <Andrew.Jackson@arm.com> wrote:
> 
>> Fetching the EDID from a connected monitor is an automated thing
>> with NXP TDA19988. But on some boards the fetching fails for the
>> first time silently without any indication that an error has occured.
>> More than that, subsequent fetches of the EDID succeed until the
>> monitor(s) are unplugged.
>>
>> Add a function to validate the read EDID and retry if the block
>> retrieved is not valid.
>>
>> Signed-off-by: Andrew Jackson <Andrew.Jackson@arm.com>
>> Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> 
> It seems that your patch is deprecated by Laurent Pinchart's
> 	[PATCH] drm: tda998x: Use drm_do_get_edid()
> http://lists.freedesktop.org/archives/dri-devel/2014-November/072906.html
> 

Thank you for the heads-up, I'd not seen that.  I'll consider how my patch might be modified to suit the new infrastructure.

    Andrew

