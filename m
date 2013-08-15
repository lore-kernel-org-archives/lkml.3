Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136Ab3HOMqf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 08:46:35 -0400
Received: from mail-qe0-f44.google.com ([209.85.128.44]:65389 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927Ab3HOMqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 08:46:34 -0400
MIME-Version: 1.0
In-Reply-To: <520CCB70.8090908@gmail.com>
References: <1376564133-11286-1-git-send-email-b29396@freescale.com> <520CCB70.8090908@gmail.com>
From: Grant Likely <grant.likely@linaro.org>
Date: Thu, 15 Aug 2013 13:46:12 +0100
X-Google-Sender-Auth: QaHgLE0dtVk9i6xQzJ-CzS2wJTc
Message-ID: <CACxGe6tdvdFsAHjEZK8fuHNEgV+JW8K2GfLN0gD3HfSopb4Kfw@mail.gmail.com>
Subject: Re: [PATCH 0/3] of: add update device node status via cmdline feature
To: Rob Herring <robherring2@gmail.com>
Cc: Dong Aisheng <b29396@freescale.com>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Landley <rob@landley.net>, Rob Herring <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 1:37 PM, Rob Herring <robherring2@gmail.com> wrote:
> On 08/15/2013 05:55 AM, Dong Aisheng wrote:
>> We meet some boards having a lot of pin conflicts between different devices,
>> only one of them can be enabled to run at one time.
>>
>> e.g. imx6q sabreauto board, i2c, spi, weim, flexcan, uart and etc involved
>> with pin conflict.
>>
>> Instead of changing dts manually or adding a lot dts files according to
>> different device availability, we provide feature to dynamically update the
>> device node status via command line, then those devices involved with
>> pin conflict can be enabled or disabled dynamically.
>>
>> It's conveniently to use and can save a lot dts board files, also can
>> permenantly fix the pin conflicts issue.
>
> This doesn't scale either with updating of lots devices or when the next
> person comes along and wants to edit another property.
>
> This is something u-boot is perfectly capable of handling and updating
> status is something lots of boards already do.

+1

g.
