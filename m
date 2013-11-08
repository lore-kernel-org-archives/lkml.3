Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757659Ab3KHRea (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 12:34:30 -0500
Received: from multi.imgtec.com ([194.200.65.239]:41596 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756350Ab3KHRe2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 12:34:28 -0500
Message-ID: <527D209A.8090305@imgtec.com>
Date: Fri, 8 Nov 2013 17:34:18 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        linux-metag <linux-metag@vger.kernel.org>,
        Qais <qais.yousef@imgtec.com>, Qais Yousef <qsyousef@gmail.com>
Subject: Re: [PATCH v2 08/29] metag: use unflatten_and_copy_device_tree
References: <1381163377-21044-1-git-send-email-robherring2@gmail.com> <1381163377-21044-9-git-send-email-robherring2@gmail.com> <527CE32F.6090305@imgtec.com> <CAL_JsqKprnCn7JQj7QFbMbLW3Ei-paBH6RYti+CgEFCb4JUaAQ@mail.gmail.com>
In-Reply-To: <CAL_JsqKprnCn7JQj7QFbMbLW3Ei-paBH6RYti+CgEFCb4JUaAQ@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_11_08_17_34_20
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/13 17:26, Rob Herring wrote:
> On Fri, Nov 8, 2013 at 7:12 AM, James Hogan <james.hogan@imgtec.com> wrote:
>> On 07/10/13 17:29, Rob Herring wrote:
>>> From: Rob Herring <rob.herring@calxeda.com>
>>>
>>> Use the common unflatten_and_copy_device_tree to copy the built-in FDT
>>> out of init section.
>>>
>>> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
>>> Cc: James Hogan <james.hogan@imgtec.com>
>>
>> With Qais' suggestion of removing the extern void copy_fdt(void) from
>> arch/metag/include/asm/prom.h (thanks Qais):
>> Acked-by: James Hogan <james.hogan@imgtec.com>
> 
> Look at the second series with the prom.h clean-up. prom.h is removed
> from metag altogether now.

Ah yes. It should technically be removed in this patch, but since prom.h
is going away anyway it doesn't particularly bother me.

Thanks
James

