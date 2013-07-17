Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab3GQAcV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 20:32:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33024 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755226Ab3GQAcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 20:32:20 -0400
Message-ID: <51E5E604.9050003@zytor.com>
Date: Tue, 16 Jul 2013 17:32:04 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Fleming, Matt" <matt.fleming@intel.com>
CC: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Seth Forshee <seth.forshee@canonical.com>,
        Dave Young <dyoung@redhat.com>
Subject: Re: [REGRESSION] "UEFI: Don't pass boot services regions to SetVirtualAddressMap()"
 breaks macbook efi boot
References: <51DD46AD.2010800@canonical.com> <CAL01qptsrtZCGUh-w1R4a2C_ez+wX1-5xo0Bk6Nmzf-aLfBH7g@mail.gmail.com>
In-Reply-To: <CAL01qptsrtZCGUh-w1R4a2C_ez+wX1-5xo0Bk6Nmzf-aLfBH7g@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2013 04:39 AM, Fleming, Matt wrote:
> On 10 July 2013 12:34, Maarten Lankhorst
> <maarten.lankhorst@canonical.com> wrote:
>> Hey,
>>
>> It seems that in the merge window my macbook pro stopped working at some point. I looked for suspicious
>> efi related commits, and found that reverting commit 1acba98f810a14b1255e34bc620594f83de37e36 worked,
>> letting my macbook pro boot succesfully.
> 
> Thanks for the report. I'm going to queue up a revert of this patch,
> Dave Young also reported a problem on his thinkpad.
> 

Can I grab this somewhere yet?

	-hpa


