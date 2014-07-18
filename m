Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751277AbaGREJW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 00:09:22 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:50160 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbaGREJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 00:09:21 -0400
From: Roger Qiu <roger.qiu@polycademy.com>
X-Google-Original-From: Roger Qiu <roger.qiu@matrix.ai>
Message-ID: <53C89DEF.7040006@matrix.ai>
Date: Fri, 18 Jul 2014 14:09:19 +1000
Reply-To: roger.qiu@matrix.ai
Organization: Matrix AI
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Fast TSC calibration failed error
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I noticed that the `arch/x86/kernel/tsc.c` has a pending patch to make 
this message:

```
Fast TSC calibration failed
```

into an Information Message instead of Error message.

This the original post: 
http://lkml.iu.edu//hypermail/linux/kernel/1209.3/00224.html

And here was the patch: https://lkml.org/lkml/2012/9/26/131 & 
https://lkml.org/lkml/2012/9/26/169

What's the status of this patch?

It would be nice for this to be accepted, since the Fast TSC calibration 
failed message clogs up all my logs for all my Linux virtual machines.

It ends up being a redundant message for centralised logging systems 
that always needs to be filtered out.

Thanks,
Roger
