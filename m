Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab3EMUEE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 16:04:04 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59474 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755154Ab3EMUEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 16:04:02 -0400
Message-ID: <5191472D.7060601@gmail.com>
Date: Mon, 13 May 2013 22:03:57 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Jason Cooper <jason@lakedaemon.net>
CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] pinctrl: dove: add PMU functions to pinctrl
References: <1367883368-27889-1-git-send-email-sebastian.hesselbarth@gmail.com> <20130513200002.GY31290@titan.lakedaemon.net>
In-Reply-To: <20130513200002.GY31290@titan.lakedaemon.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2013 10:00 PM, Jason Cooper wrote:
> On Tue, May 07, 2013 at 01:36:08AM +0200, Sebastian Hesselbarth wrote:
>> Dove power management unit can mux some special functions to mpp0-15.
>> This patch adds support to set/get the current PMU function mapped
>> to the corresponding mpp pins. The device tree documentation is also
>> updated accordingly.
>>
>> Signed-off-by: Sebastian Hesselbarth<sebastian.hesselbarth@gmail.com>
>
> Do you intend to have anything depending on these changes in this merge
> window?

Jason,

I don't. There will be pmu and pmic support someday but I am not working
on it.

Sebastian
