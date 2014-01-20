Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579AbaATOf2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 09:35:28 -0500
Received: from mail-qc0-f177.google.com ([209.85.216.177]:42550 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbaATOfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 09:35:25 -0500
Message-ID: <52DD3427.9020502@redhat.com>
Date: Mon, 20 Jan 2014 15:35:19 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130923 Thunderbird/17.0.9
MIME-Version: 1.0
To: "Liu, Jinsong" <jinsong.liu@intel.com>
CC: "gleb@redhat.com" <gleb@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ren, Qiaowei" <qiaowei.ren@intel.com>
Subject: Re: [PATCH v2 0/4] X86/KVM: enable Intel MPX for KVM
References: <1386394315-48984-1-git-send-email-jinsong.liu@intel.com> <DE8DF0795D48FD4CA783C40EC82923350141B4A7@SHSMSX101.ccr.corp.intel.com> <52A83606.40908@redhat.com> <DE8DF0795D48FD4CA783C40EC829233501421D73@SHSMSX101.ccr.corp.intel.com> <52A98548.9010008@redhat.com> <DE8DF0795D48FD4CA783C40EC829233501422743@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <DE8DF0795D48FD4CA783C40EC829233501422743@SHSMSX101.ccr.corp.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 12/12/2013 12:09, Liu, Jinsong ha scritto:
> Paolo Bonzini wrote:
>> Il 12/12/2013 06:47, Liu, Jinsong ha scritto:
>>> Paolo Bonzini wrote:
>>>> Il 11/12/2013 09:31, Liu, Jinsong ha scritto:
>>>>> Paolo, comments for version 2?
>>>>
>>>> I think I commented that it's fine, I'm just waiting for a rebase
>>>> on top of the generic patches. 
>>>>
>>>> Paolo
>>>>
>>>
>>> Thanks! common MPX definiation patches have been checked in tip tree
>>> (both Qiaowei and I use that definiations):
>>> http://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/commit/?id=191f57c137bcce0e3e9313acb77b2f114d15afbb
>>> http://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/commit/?id=e7d820a5e549b3eb6c3f9467507566565646a669
>>
>> Ok, can you rebase and resend?
>>
>> Paolo
> 
> Sure, I have pulled and rebased on git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git
> No confliction, patches v3 will send out later.

Didn't see this...  You still have a couple of days to send it out and
address the review remarks.

Paolo
