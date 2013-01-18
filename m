Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038Ab3ARObt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 09:31:49 -0500
Received: from mail-bk0-f45.google.com ([209.85.214.45]:47082 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461Ab3ARObr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 09:31:47 -0500
MIME-Version: 1.0
In-Reply-To: <20130118131617.GI4672@arwen.pp.htv.fi>
References: <1357916550-11421-1-git-send-email-gautam.vivek@samsung.com>
	<1357916550-11421-4-git-send-email-gautam.vivek@samsung.com>
	<20130118131617.GI4672@arwen.pp.htv.fi>
Date: Fri, 18 Jan 2013 20:01:45 +0530
Message-ID: <CAFp+6iEonM8Kp0LztsqaQ0G1+425tK9f06hyUBeQkbvOaHOzeA@mail.gmail.com>
Subject: Re: [PATCH v6 3/4] USB: ehci-s5p: Add phy driver support
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: balbi@ti.com, Alan Stern <stern@rowland.harvard.edu>
Cc: Vivek Gautam <gautam.vivek@samsung.com>, jg1.han@samsung.com,
        linux-samsung-soc@vger.kernel.org, p.paneri@samsung.com,
        gregkh@linuxfoundation.org, devicetree-discuss@lists.ozlabs.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        kgene.kim@samsung.com, rob.herring@calxeda.com,
        sylvester.nawrocki@gmail.com, Doug Anderson <dianders@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,


On Fri, Jan 18, 2013 at 6:46 PM, Felipe Balbi <balbi@ti.com> wrote:
> On Fri, Jan 11, 2013 at 08:32:29PM +0530, Vivek Gautam wrote:
>> Adding the phy driver to ehci-s5p. Keeping the platform data
>> for continuing the smooth operation for boards which still uses it
>>
>> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>> Acked-by: Jingoo Han <jg1.han@samsung.com>
>
> Missing Alan's Acked-by here.
>

Any comments on this patch-series ?


-- 
Thanks & Regards
Vivek
