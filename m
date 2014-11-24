Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908AbaKXLJm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 06:09:42 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:51508 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbaKXLJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 06:09:39 -0500
Message-ID: <5473119F.5060707@linaro.org>
Date: Mon, 24 Nov 2014 12:08:15 +0100
From: Eric Auger <eric.auger@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>
CC: "eric.auger@st.com" <eric.auger@st.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "joel.schopp@amd.com" <joel.schopp@amd.com>,
        "kim.phillips@freescale.com" <kim.phillips@freescale.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "gleb@kernel.org" <gleb@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "a.motakis@virtualopensystems.com" <a.motakis@virtualopensystems.com>,
        "a.rigo@virtualopensystems.com" <a.rigo@virtualopensystems.com>,
        "john.liuli@huawei.com" <john.liuli@huawei.com>,
        "ming.lei@canonical.com" <ming.lei@canonical.com>,
        "feng.wu@intel.com" <feng.wu@intel.com>
Subject: Re: [RFC 0/4] vgic additions for forwarded irq
References: <1416766373-13569-1-git-send-email-eric.auger@linaro.org> <20141124105037.GL3401@cbox> <54730E6C.1040708@arm.com>
In-Reply-To: <54730E6C.1040708@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2014 11:54 AM, Marc Zyngier wrote:
> On 24/11/14 10:50, Christoffer Dall wrote:
>> On Sun, Nov 23, 2014 at 07:12:49PM +0100, Eric Auger wrote:
>>> This series applies on top of "ARM: Forwarding physical
>>> interrupts to a guest VM" (http://lwn.net/Articles/603514/)
>>> series.
>>
>> Marc and Eric,
>>
>> Does it make sense to review and look at these patches given the current
>> state of the forwarding patches, or should we wait until Marc respins
>> that series?
> 
> I'm still in the process of respining all of this (we've had a few
> iterations with tglx, but I got sidetracked with the ITS/v2m/MSI side of
> things).

Hi Marc, Christoffer,

for your info, I integrated with kvm-arm64/irq-forward branch prior to
ITS integration, not with the RFC.

Best Regards

Eric

> 
> I'll get back onto this this week. Hopefully.
> 
> Thanks,
> 
> 	M.
> 

