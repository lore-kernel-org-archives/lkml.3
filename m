Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468AbaA3Rdy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 12:33:54 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:19337 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752064AbaA3Rdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 12:33:53 -0500
Message-ID: <52EA8CFE.7020404@arm.com>
Date: Thu, 30 Jan 2014 17:33:50 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Will Deacon <Will.Deacon@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH] arm: document "mach-virt" platform.
References: <1391098262-15944-1-git-send-email-ian.campbell@citrix.com> <201401301828.59294.arnd@arndb.de>
In-Reply-To: <201401301828.59294.arnd@arndb.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/01/14 17:28, Arnd Bergmann wrote:
> On Thursday 30 January 2014, Ian Campbell wrote:
>> mach-virt has existed for a while but it is not written down what it actually
>> consists of. Although it seems a bit unusual to document a binding for an
>> entire platform since mach-virt is entirely virtual it is helpful to have
>> something to refer to in the absence of a single concrete implementation.
>>
>> I've done my best to capture the requirements based on the git log and my
>> memory/understanding.
>>
>> While here remove the xenvm dts example, the Xen tools will now build a
>> suitable mach-virt compatible dts when launching the guest.
> 
> It might be worth noting in the changeset comment that the 'compatible'
> string is actually no longer needed on newer kernels: All the members
> of the machine descriptor are now the defaults (we should remove the
> virt_init() function as well), and the fallback machine descriptor should
> work just fine if any other string gets passed.

I will ack the patch that removes the mach-virt directory altogether!

	M.
-- 
Jazz is not dead. It just smells funny...
