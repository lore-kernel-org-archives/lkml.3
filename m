Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935AbbANC21 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 21:28:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004AbbANC20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 21:28:26 -0500
Date: Wed, 14 Jan 2015 02:36:00 +0008
From: Jason Wang <jasowang@redhat.com>
Subject: RE: [PATCH v3] hv: hv_fcopy: drop the obsolete message on transfer
 failure
To: Dexuan Cui <decui@microsoft.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>, KY Srinivasan <kys@microsoft.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Message-Id: <1421202480.4752.0@smtp.corp.redhat.com>
In-Reply-To: <F792CF86EFE20D4AB8064279AFBA51C61EA7CFF9@SIXPRD3002MB028.064d.mgd.msft.net
	>
References: <1417093747-21073-1-git-send-email-decui@microsoft.com>
	<8761caeqjp.fsf@vitty.brq.redhat.com>
	<F792CF86EFE20D4AB8064279AFBA51C61EA7CFF9@SIXPRD3002MB028.064d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, Jan 14, 2015 at 9:43 AM, Dexuan Cui <decui@microsoft.com> wrote:
>>  -----Original Message-----
>>  From: Vitaly Kuznetsov [mailto:vkuznets@redhat.com]
>>  Sent: Tuesday, January 13, 2015 21:52 PM
>>  To: Dexuan Cui; KY Srinivasan
>>  Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org; 
>> driverdev-
>>  devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
>>  jasowang@redhat.com; Haiyang Zhang
>>  Subject: Re: [PATCH v3] hv: hv_fcopy: drop the obsolete message on 
>> transfer
>>  failure
>>  
>>  Dexuan Cui <decui@microsoft.com> writes:
>>  
>>  > In the case the user-space daemon crashes, hangs or is killed, we
>>  > need to down the semaphore, otherwise, after the daemon starts 
>> next
>>  > time, the obsolete data in fcopy_transaction.message or
>>  > fcopy_transaction.fcopy_msg will be used immediately.
>>  
>>  It seems this patch got lost and I don't see it in recent 'resend'
>>  series. K.Y., Dexuan, can you please take a look?
> Hi Vitaly, Jason,
> The patch can't fix all the corner cases (it would need non-trivial 
> efforts for that)
> as we discussed, but I think it would be better for us to have it as 
> it can indeed fix
> an obvious issue and doesn't introduce new issues.
> 
> I think I can document the known discussed corner cases in the patch 
> as TODOs
> and resend the patch.
> 
> Please let me know if you have different opinions. :-) 
> 
> Thanks,
> -- Dexuan

Yes, I think it's ok.
We can do other fixes on top.

Thanks

