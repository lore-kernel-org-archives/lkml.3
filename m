Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab3IJIdS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 04:33:18 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:55895 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752352Ab3IJIdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 04:33:15 -0400
Message-ID: <522ED944.8040206@ti.com>
Date: Tue, 10 Sep 2013 14:03:08 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: George Cherian <george.cherian@ti.com>
CC: <linux-kernel@vger.kernel.org>, <myungjoo.ham@samsung.com>,
        <cw00.choi@samsung.com>, <ldewangan@nvidia.com>
Subject: Re: [PATCH] extcon: palmas: Dont set USB state if ID pin is grounded
References: <1378799369-15803-1-git-send-email-george.cherian@ti.com> <522ED75B.4070809@ti.com> <522ED8E0.1030803@ti.com>
In-Reply-To: <522ED8E0.1030803@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 September 2013 02:01 PM, George Cherian wrote:
> On 9/10/2013 1:54 PM, Kishon Vijay Abraham I wrote:
>> Hi,
>>
>> On Tuesday 10 September 2013 01:19 PM, George Cherian wrote:
>>> In OMAP5 when USB-HOST is set true, the VBUS regulator  is turned ON.
>>> This causes a VBUS interrupt, ignore the same if we are already in
>>> USB-HOST.
>> You'll get VBUS interrupt when detaching USB-HOST cable also no? (because you
>> do a regulator disable to SMPS10).
> Yes since we are ignoring the previous interrupt(for attach), the detach is
> accounted as a spurious one.
> If we dont igonre the attach then the USB is set to true, which is wrong.

Alright, thanks.

-Kishon
