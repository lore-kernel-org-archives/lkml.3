Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651AbaEPH3r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 03:29:47 -0400
Received: from top.free-electrons.com ([176.31.233.9]:38229 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751231AbaEPH3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 03:29:46 -0400
Message-ID: <5375BE67.8000103@free-electrons.com>
Date: Fri, 16 May 2014 09:29:43 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Randy Dunlap <rdunlap@infradead.org>, David Airlie <airlied@linux.ie>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] drm/panel: add simple-panel description using
 DT
References: <1399645002-18000-1-git-send-email-boris.brezillon@free-electrons.com> <20140513075148.GF6754@ulmo>
In-Reply-To: <20140513075148.GF6754@ulmo>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 13/05/2014 09:51, Thierry Reding wrote:
> On Fri, May 09, 2014 at 04:16:40PM +0200, Boris BREZILLON wrote:
>> Hello Thierry,
>>
>> I noticed you're describing each new panel with a new entry in the
>> of_platform_match table and a new compatible string.
>> I guess you have a good reason to do it this way, because retrieving
>> panel description from DT would be pretty easy (see this series ;-)).
>>
>> Could tell me why you chose this approach ?
> The reason is that devicetree mandates that a device be identified using
> a compatible value and that compatible value should be as specific as
> possible. That compatible value should give the device driver enough
> information to know everything it needs (resolution, timings, physical
> dimension).
>
> Having all of that data in the device tree is redundant.

Okay, thanks for your answer.

As a result, you'll see a patch adding support for the FL500WVR00-A0T
(foxlink) panel soon ;-).

Best Regards,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

