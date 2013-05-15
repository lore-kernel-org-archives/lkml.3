Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166Ab3EOEMh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 00:12:37 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:38801 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751060Ab3EOEMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 00:12:36 -0400
X-IronPort-AV: E=Sophos;i="4.87,675,1363104000"; 
   d="scan'208";a="7272583"
Message-ID: <519301D8.2030502@cn.fujitsu.com>
Date: Wed, 15 May 2013 11:32:40 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, JBottomley@parallels.com,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/2] Kernel/time: Introduce a new timestamp function local_time_seconds()
References: <5191EBA7.9010303@cn.fujitsu.com> <51925EDC.2080307@linaro.org>
In-Reply-To: <51925EDC.2080307@linaro.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/15 11:33:42,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/15 11:33:45,
	Serialize complete at 2013/05/15 11:33:45
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2013 11:57 PM, John Stultz wrote:

> On 05/14/2013 12:45 AM, Gu Zheng wrote:
>>  From 18072c1c3506a7e37ee485307a2c343efe5af4d0 Mon Sep 17 00:00:00 2001
>> From: Gu Zheng <guz.fnst@cn.fujitsu.com>
>> Date: Mon, 13 May 2013 15:45:24 +0900
>> Subject: [PATCH 1/2] Kernel/time: Introduce a new timestamp function local_time_seconds()
>>
>> Introduce a new timestamp function local_time_seconds() to hide the conversion of system time in UTC to local time seconds.
> 
> So, why is this useful/needed?

Hi John,
   There are some subsystems use local time seconds as a timestamp, such as scsi(refer to:http://www.spinics.net/lists/linux-scsi/msg66089.html),
and so do many out-of-kernel-tree code I think.

Best regards,
Gu

> 
> thanks
> -john
> 
> 


