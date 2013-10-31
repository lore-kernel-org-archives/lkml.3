Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab3JaDNw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 23:13:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41703 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182Ab3JaDNv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 23:13:51 -0400
Message-ID: <5271C981.2050705@zytor.com>
Date: Wed, 30 Oct 2013 20:07:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Dave Young <dyoung@redhat.com>, Borislav Petkov <bp@alien8.de>
CC: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, James.Bottomley@HansenPartnership.com,
        vgoyal@redhat.com, ebiederm@xmission.com, horms@verge.net.au,
        kexec@lists.fedoraproject.org, kexec@lists.infradead.org
Subject: Re: [patch 3/6] Cleanup efi_enter_virtual_mode function
References: <20131028101011.GF25527@dhcp-16-126.nay.redhat.com> <20131028112045.GH4314@pd.tnic> <20131028112458.GD29133@dhcp-16-126.nay.redhat.com> <20131028145801.GM4314@pd.tnic> <20131028151048.GA14984@dhcp-16-126.nay.redhat.com> <20131029023203.GB5185@dhcp-16-126.nay.redhat.com> <20131029134302.GI10972@pd.tnic> <20131030020348.GA4332@dhcp-16-126.nay.redhat.com> <20131030104718.GB13290@pd.tnic> <20131031020405.GA4377@dhcp-16-126.nay.redhat.com> <20131031020714.GB4377@dhcp-16-126.nay.redhat.com>
In-Reply-To: <20131031020714.GB4377@dhcp-16-126.nay.redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2013 07:07 PM, Dave Young wrote:
> On 10/31/13 at 10:04am, Dave Young wrote:
>> On 10/30/13 at 11:47am, Borislav Petkov wrote:
>>> On Wed, Oct 30, 2013 at 10:03:49AM +0800, Dave Young wrote:
>>>> Will try, but please keep the posted patches in mailing list up-to-date,
>>>
>>> Would you like me to send them to you privately?
>>
>> Thanks, do not bother to send me privately I can get it from your git tree.
>>
>> But Frankly I'd like to see them in list instead even with only small fixes
>> beacuse in this way there might be more people to review it carefully.
> 
> There's another shorcoming for keeping new patches in git is that nobody know
> when you push it and when is the proper date to pull from your git. I think
> it's better to use git only for the patches which have already been accepted
> and is waiting for maintainer to pull.
> 

You can use git for your own purposes, still.

	-hpa


