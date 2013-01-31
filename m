Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821Ab3AaSbA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 13:31:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41773 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342Ab3AaSa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 13:30:58 -0500
Message-ID: <510AB803.2010004@zytor.com>
Date: Thu, 31 Jan 2013 10:29:23 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: KY Srinivasan <kys@microsoft.com>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "bp@alien8.de" <bp@alien8.de>, "apw@canonical.com" <apw@canonical.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] X86: Add a check to catch Xen emulation of Hyper-V
References: <1359507077-26050-1-git-send-email-kys@microsoft.com> <1359507108-26091-1-git-send-email-kys@microsoft.com> <1359507108-26091-2-git-send-email-kys@microsoft.com> <5108ED9702000078000BAA08@nat28.tlf.novell.com> <1db4d98aa3434d4eab7b36bbeb89cd47@SN2PR03MB061.namprd03.prod.outlook.com> <510A2D5802000078000BAEAA@nat28.tlf.novell.com> <32e50a43db8849f2944db256989bebb8@SN2PR03MB061.namprd03.prod.outlook.com> <fe91cec766464b4fbfeea56d7e5de0a0@SN2PR03MB061.namprd03.prod.outlook.com> <510AADBE02000078000BB190@nat28.tlf.novell.com>
In-Reply-To: <510AADBE02000078000BB190@nat28.tlf.novell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2013 08:45 AM, Jan Beulich wrote:
>>>> On 31.01.13 at 16:53, KY Srinivasan <kys@microsoft.com> wrote:
>> Are there any published standards in terms of how the CPUID space should be
>> populated in the range from 0x40000000 to 0x40010000. Specifically, unless
>
> I recall having seen this range being marked as reserved for
> hypervisor use somewhere, but I don't remember where that was.
>

AFAIK Intel reserves 0x40000000 to 0x4FFFFFFF for hypervisor use. 
Typically multivendor CPUID utilities expect "blocks" of 64K but that is 
not in any spec that I know of.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

