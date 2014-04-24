Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762AbaDXAvn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 20:51:43 -0400
Received: from exprod5og104.obsmtp.com ([64.18.0.178]:42137 "HELO
	exprod5og104.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751636AbaDXAvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 20:51:40 -0400
MIME-Version: 1.0
In-Reply-To: <CABxcv=mj+phHmyg2U2jW51mLTwBN9Au791m-GtqU5BXDPy7Gtg@mail.gmail.com>
References: <1397702368-4846-1-git-send-email-isubramanian@apm.com>
	<1397702368-4846-2-git-send-email-isubramanian@apm.com>
	<1397704685.14062.14.camel@joe-AO725>
	<CABxcv=mj+phHmyg2U2jW51mLTwBN9Au791m-GtqU5BXDPy7Gtg@mail.gmail.com>
Date: Wed, 23 Apr 2014 17:51:38 -0700
Message-ID: <CAKh23F=Ukhufm3XMmSmaTU3AvmeoDDMeFwodgU-B_XH09sdbOQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] MAINTAINERS: Add entry for APM X-Gene SoC ethernet driver
From: Iyappan Subramanian <isubramanian@apm.com>
To: Javier Martinez Canillas <javier@dowhile0.org>
Cc: Joe Perches <joe@perches.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "jcm@redhat.com" <jcm@redhat.com>, netdev <netdev@vger.kernel.org>,
        patches <patches@apm.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Keyur Chudgar <kchudgar@apm.com>, David Miller <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ravi Patel <rapatel@apm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Javier,

On Sun, Apr 20, 2014 at 5:56 PM, Javier Martinez Canillas
<javier@dowhile0.org> wrote:
> Hello Lyappan,
>
> On Thu, Apr 17, 2014 at 5:18 AM, Joe Perches <joe@perches.com> wrote:
>> On Wed, 2014-04-16 at 19:39 -0700, Iyappan Subramanian wrote:
>>> This patch adds a MAINTAINERS entry for APM X-Gene SoC
>>> ethernet driver.
>> []
>>> diff --git a/MAINTAINERS b/MAINTAINERS
>> []
>>> @@ -686,6 +686,14 @@ S:       Maintained
>>>  F:   drivers/net/appletalk/
>>>  F:   net/appletalk/
>>>
>>> +APPLIED MICRO (APM) X-GENE SOC ETHERNET DRIVER
>>> +M:   Iyappan Subramanian <isubramanian@apm.com>
>>> +M:   Keyur Chudgar <kchudgar@apm.com>
>>> +M:   Ravi Patel <rapatel@apm.com>
>>> +S:   Maintained
>>> +F:   drivers/net/ethernet/apm/xgene
>>
>> Please add a terminating slash to show this is a directory.
>>
>> F:      drivers/net/ethernet/apm/xgene/
>>
>
> Also if you are maintaining this driver as a part of your daily work
> (i.e: actually being paid for it by your company) the status should be
> "Supported" instead.
>
> If you are doing it on your own time but still using your company
> email address then "Maintained" is correct.

Thanks.  I will change this to Supported.

>
> Best regards,
> Javier
