Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbaKXKyy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 05:54:54 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:37683 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854AbaKXKyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 05:54:52 -0500
Message-ID: <54730E6C.1040708@arm.com>
Date: Mon, 24 Nov 2014 10:54:36 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Christoffer Dall <christoffer.dall@linaro.org>,
        Eric Auger <eric.auger@linaro.org>
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
References: <1416766373-13569-1-git-send-email-eric.auger@linaro.org> <20141124105037.GL3401@cbox>
In-Reply-To: <20141124105037.GL3401@cbox>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/11/14 10:50, Christoffer Dall wrote:
> On Sun, Nov 23, 2014 at 07:12:49PM +0100, Eric Auger wrote:
>> This series applies on top of "ARM: Forwarding physical
>> interrupts to a guest VM" (http://lwn.net/Articles/603514/)
>> series.
> 
> Marc and Eric,
> 
> Does it make sense to review and look at these patches given the current
> state of the forwarding patches, or should we wait until Marc respins
> that series?

I'm still in the process of respining all of this (we've had a few
iterations with tglx, but I got sidetracked with the ITS/v2m/MSI side of
things).

I'll get back onto this this week. Hopefully.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
