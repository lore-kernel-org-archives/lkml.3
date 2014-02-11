Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845AbaBKQbc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 11:31:32 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:58716 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452AbaBKQb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 11:31:29 -0500
MIME-Version: 1.0
In-Reply-To: <20140211162943.GB12106@core.coreip.homeip.net>
References: <1392132520-2497-1-git-send-email-andrew.smirnov@gmail.com>
	<20140211162943.GB12106@core.coreip.homeip.net>
Date: Tue, 11 Feb 2014 08:31:28 -0800
Message-ID: <CAHQ1cqHLXMrxQuCHgfKtKizrrbEuWvOGL9dLfo0cbNmsWBAMPQ@mail.gmail.com>
Subject: Re: [PATCH v4 RESEND] ims-pcu: Add commands supported by the new
 version of the FW
From: Andrey Smirnov <andrew.smirnov@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 8:29 AM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> Hi Andrey,
>
> On Tue, Feb 11, 2014 at 07:28:40AM -0800, Andrey Smirnov wrote:
>> New version of the PCU firmware supports two new commands:
>>   - IMS_PCU_CMD_OFN_SET_CONFIG which allows to write data to the
>>   registers of one finger navigation(OFN) chip present on the device
>>   - IMS_PCU_CMD_OFN_GET_CONFIG which allows to read data form the
>>   registers of said chip.
>>
>> This commit adds two helper functions to use those commands and sysfs
>> attributes to use them. It also exposes some OFN configuration
>> parameters via sysfs.
>>
>> Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
>> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
>
> I have it queued for the next merge window.
>
> Thanks.

Awesome, thank you so much!

>
> --
> Dmitry
