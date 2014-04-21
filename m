Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751329AbaDUA4r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 20:56:47 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:56335 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbaDUA4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 20:56:43 -0400
MIME-Version: 1.0
X-Originating-IP: [95.21.51.154]
In-Reply-To: <1397704685.14062.14.camel@joe-AO725>
References: <1397702368-4846-1-git-send-email-isubramanian@apm.com>
	<1397702368-4846-2-git-send-email-isubramanian@apm.com>
	<1397704685.14062.14.camel@joe-AO725>
Date: Mon, 21 Apr 2014 02:56:41 +0200
Message-ID: <CABxcv=mj+phHmyg2U2jW51mLTwBN9Au791m-GtqU5BXDPy7Gtg@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] MAINTAINERS: Add entry for APM X-Gene SoC ethernet driver
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Joe Perches <joe@perches.com>
Cc: Iyappan Subramanian <isubramanian@apm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        jcm@redhat.com, netdev@vger.kernel.org, patches@apm.com,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Keyur Chudgar <kchudgar@apm.com>, davem@davemloft.net,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ravi Patel <rapatel@apm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Lyappan,

On Thu, Apr 17, 2014 at 5:18 AM, Joe Perches <joe@perches.com> wrote:
> On Wed, 2014-04-16 at 19:39 -0700, Iyappan Subramanian wrote:
>> This patch adds a MAINTAINERS entry for APM X-Gene SoC
>> ethernet driver.
> []
>> diff --git a/MAINTAINERS b/MAINTAINERS
> []
>> @@ -686,6 +686,14 @@ S:       Maintained
>>  F:   drivers/net/appletalk/
>>  F:   net/appletalk/
>>
>> +APPLIED MICRO (APM) X-GENE SOC ETHERNET DRIVER
>> +M:   Iyappan Subramanian <isubramanian@apm.com>
>> +M:   Keyur Chudgar <kchudgar@apm.com>
>> +M:   Ravi Patel <rapatel@apm.com>
>> +S:   Maintained
>> +F:   drivers/net/ethernet/apm/xgene
>
> Please add a terminating slash to show this is a directory.
>
> F:      drivers/net/ethernet/apm/xgene/
>

Also if you are maintaining this driver as a part of your daily work
(i.e: actually being paid for it by your company) the status should be
"Supported" instead.

If you are doing it on your own time but still using your company
email address then "Maintained" is correct.

Best regards,
Javier
