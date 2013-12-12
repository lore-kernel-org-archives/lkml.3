Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431Ab3LLJnr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 04:43:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46150 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120Ab3LLJno (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 04:43:44 -0500
Message-ID: <52A98548.9010008@redhat.com>
Date: Thu, 12 Dec 2013 10:43:36 +0100
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
References: <1386394315-48984-1-git-send-email-jinsong.liu@intel.com> <DE8DF0795D48FD4CA783C40EC82923350141B4A7@SHSMSX101.ccr.corp.intel.com> <52A83606.40908@redhat.com> <DE8DF0795D48FD4CA783C40EC829233501421D73@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <DE8DF0795D48FD4CA783C40EC829233501421D73@SHSMSX101.ccr.corp.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 12/12/2013 06:47, Liu, Jinsong ha scritto:
> Paolo Bonzini wrote:
>> Il 11/12/2013 09:31, Liu, Jinsong ha scritto:
>>> Paolo, comments for version 2?
>>
>> I think I commented that it's fine, I'm just waiting for a rebase on
>> top of the generic patches.
>>
>> Paolo
>>
> 
> Thanks! common MPX definiation patches have been checked in tip tree (both Qiaowei and I use that definiations):
> http://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/commit/?id=191f57c137bcce0e3e9313acb77b2f114d15afbb
> http://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/commit/?id=e7d820a5e549b3eb6c3f9467507566565646a669

Ok, can you rebase and resend?

Paolo

