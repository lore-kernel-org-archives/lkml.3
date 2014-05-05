Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751250AbaEESQU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 14:16:20 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:65498 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbaEESQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 14:16:19 -0400
Message-ID: <5367D566.7000601@gmail.com>
Date: Mon, 05 May 2014 23:46:06 +0530
From: RAGHAVENDRA GANIGA <ravi23ganiga@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: a.zummo@towertech.it, rtc-linux@googlegroups.com
CC: linux-kernel@vger.kernel.org
Subject: rtc: add support for maxim dallas rtc ds1343 and ds1344
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 30 Apr 2014 21:55:07 +0530
> Raghavendra Ganiga <ravi23ganiga@gmail.com> wrote:
>> +static int ds1343_proc(struct device *dev, struct seq_file *seq)
>> +{
>> +     struct ds1343_priv *priv = dev_get_drvdata(dev);
>> +     unsigned int data;
>> +     unsigned char alarm_mode = 0;
>> +     const char *alarm_str, *diodes = "disabled", *resistors = " ";
>> +
>> +     regmap_read(priv->map, DS1343_CONTROL_REG, &data);
>  is this thing really useful? what about having sysfs entries
>  instead?



i am replacing the proc interface with the sysfs entries
also removing the unnecessary parameters. i am adding the
following parameters as sysfs entries

1. glitch filter read and write parameter
2. alarm status read parameter
3. alarm mode read parameter
4. trickle charger read parameter

and i am removing the proc interface. 

is the above implementation ok as per your last comment
on the proc interface. please provide the feedback.

Thanks and regards
Raghavendra Chandra Ganiga

