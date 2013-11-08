Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757798Ab3KHR06 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 12:26:58 -0500
Received: from mail-ve0-f174.google.com ([209.85.128.174]:43803 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504Ab3KHR05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 12:26:57 -0500
MIME-Version: 1.0
In-Reply-To: <527CE32F.6090305@imgtec.com>
References: <1381163377-21044-1-git-send-email-robherring2@gmail.com>
	<1381163377-21044-9-git-send-email-robherring2@gmail.com>
	<527CE32F.6090305@imgtec.com>
Date: Fri, 8 Nov 2013 11:26:55 -0600
Message-ID: <CAL_JsqKprnCn7JQj7QFbMbLW3Ei-paBH6RYti+CgEFCb4JUaAQ@mail.gmail.com>
Subject: Re: [PATCH v2 08/29] metag: use unflatten_and_copy_device_tree
From: Rob Herring <robherring2@gmail.com>
To: James Hogan <james.hogan@imgtec.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        linux-metag <linux-metag@vger.kernel.org>,
        Qais <qais.yousef@imgtec.com>, Qais Yousef <qsyousef@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 8, 2013 at 7:12 AM, James Hogan <james.hogan@imgtec.com> wrote:
> On 07/10/13 17:29, Rob Herring wrote:
>> From: Rob Herring <rob.herring@calxeda.com>
>>
>> Use the common unflatten_and_copy_device_tree to copy the built-in FDT
>> out of init section.
>>
>> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
>> Cc: James Hogan <james.hogan@imgtec.com>
>
> With Qais' suggestion of removing the extern void copy_fdt(void) from
> arch/metag/include/asm/prom.h (thanks Qais):
> Acked-by: James Hogan <james.hogan@imgtec.com>

Look at the second series with the prom.h clean-up. prom.h is removed
from metag altogether now.

Rob
