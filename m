Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290Ab3BQTRi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 14:17:38 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54214 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751925Ab3BQTRh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 14:17:37 -0500
Message-ID: <51212C68.1090900@zytor.com>
Date: Sun, 17 Feb 2013 11:15:52 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: KY Srinivasan <kys@microsoft.com>
CC: Greg KH <gregkh@linuxfoundation.org>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "JBeulich@suse.com" <JBeulich@suse.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH 1/1] Drivers: hv: vmbus: Use the new infrastructure for
 delivering VMBUS interrupts
References: <20130206191313.GA1470@kroah.com> <511ADEB7.6080909@zytor.com> <ae14ef66af2d4206baf4ccb382fc4205@SN2PR03MB061.namprd03.prod.outlook.com> <20130213162211.GA21253@kroah.com> <c31482583b394bfcaa16b76a63c413fe@SN2PR03MB061.namprd03.prod.outlook.com> <511BD923.7000500@zytor.com> <20130213182349.GA4959@kroah.com> <511BDD2A.8020002@zytor.com> <20130213185239.GB16645@kroah.com> <bc26219c6d0e4a498912a8411c11f81c@SN2PR03MB061.namprd03.prod.outlook.com> <20130217182519.GB8687@kroah.com> <663c5ef1750e4aa3922c38e897c4903a@SN2PR03MB061.namprd03.prod.outlook.com>
In-Reply-To: <663c5ef1750e4aa3922c38e897c4903a@SN2PR03MB061.namprd03.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2013 10:51 AM, KY Srinivasan wrote:
>>
>> No one can base their tree on linux-next, so no.  Please wait for them
>> to get into Linus's tree.
>>
>> Or send them to me now, with the instructions to apply them after
>> 3.9-rc1, and I will save them for that point in time.
>
> Thanks Greg. Will do.
>

As I said, I'm also perfectly happy to have you take over the 
tip:x86/hyperv branch for this cycle...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

