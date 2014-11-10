Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075AbaKJSuZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 13:50:25 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:23071 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589AbaKJSuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 13:50:23 -0500
Message-ID: <5461091E.6090708@oracle.com>
Date: Mon, 10 Nov 2014 10:51:10 -0800
From: "santosh.shilimkar@oracle.com" <santosh.shilimkar@oracle.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Grygorii Strashko <grygorii.strashko@ti.com>, ssantosh@kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, khilman@linaro.org
CC: linux-pm@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        grant.likely@secretlab.ca, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH v4 0/2] ARM: keystone: pm: switch to use generic pm domains
References: <1415631557-22897-1-git-send-email-grygorii.strashko@ti.com> <5460D601.70504@ti.com>
In-Reply-To: <5460D601.70504@ti.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/14 7:13 AM, Grygorii Strashko wrote:
> Hi Santosh,
>
> On 11/10/2014 04:59 PM, Grygorii Strashko wrote:
>> Hi Santosh, Kevin,
>>
>> This series switches Keystone 2 PM code to use Generic PM domains
>> instead of PM clock domains because of the lack of DT support
>> for the last.
>> It will finally allow to enable Runtime PM for Keystone 2.
>>
>> This series based on top
>>
>> Changes in v4:
>>    - changes for Generic clock manipulation PM callbacks (clock_ops.c)
>>      were separated in standalone series [3] and Keystone 2 specific
>>      patches were rebased on top of it.
>
> I've just found that prerequisite patches have been taken by Rafael in linux-pm.git/linux-next,
> first two patches from series:
>   "[PATCH v4 0/3] PM / clock_ops: add pm_clk_add_clk()"
>   https://lkml.org/lkml/2014/11/6/319
>
> Thanks a lot Rafael.
>
> So, if no complains, this series is ready.
>
Thanks for the note and good to see the series is converged. To avoid
dependency issues, I will merge them immediately after the upcoming
merge window. Meanwhile please continue to sort out any outstanding
comments/concerns like the one you are discussing with Arnd.

regards,
Santosh
