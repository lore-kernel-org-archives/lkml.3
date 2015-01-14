Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039AbbANNDO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 08:03:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54044 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751404AbbANNDN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 08:03:13 -0500
Message-ID: <54B668D6.3070301@redhat.com>
Date: Wed, 14 Jan 2015 14:02:14 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "Wu, Feng" <feng.wu@intel.com>,
        =?UTF-8?B?UmFkaW0gS3I/bcOhPw==?= <rkrcmar@redhat.com>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>, "gleb@kernel.org" <gleb@kernel.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jiang.liu@linux.intel.com" <jiang.liu@linux.intel.com>,
        "eric.auger@linaro.org" <eric.auger@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [v3 13/26] KVM: Define a new interface kvm_find_dest_vcpu() for
 VT-d PI
References: <1418397300-10870-1-git-send-email-feng.wu@intel.com> <1418397300-10870-14-git-send-email-feng.wu@intel.com> <20150109145435.GA22469@potion.brq.redhat.com> <54AFEC00.80507@redhat.com> <E959C4978C3B6342920538CF579893F002341102@SHSMSX104.ccr.corp.intel.com> <20150113161716.GA12941@potion.brq.redhat.com> <E959C4978C3B6342920538CF579893F00234E4CD@SHSMSX104.ccr.corp.intel.com>
In-Reply-To: <E959C4978C3B6342920538CF579893F00234E4CD@SHSMSX104.ccr.corp.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 14/01/2015 02:27, Wu, Feng wrote:
> As discussed with Paolo before, as the first stage, we only support single-CPU
> lowest priority for PI, since this is a new hardware feature enabling, Paolo trends
> to do simple things in the beginning.

:)

Nice way to sum it up!

Paolo

> Then we will support full lowest priority for
> it, such as, using vector hashing (this is one method of what hardware do for
> lowest priority today), I need to get some detailed information about this from
> hardware guys before enabling it.
