Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932670AbaAaRsK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 12:48:10 -0500
Received: from mail-vb0-f44.google.com ([209.85.212.44]:65287 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932170AbaAaRsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 12:48:07 -0500
MIME-Version: 1.0
In-Reply-To: <52EA8CFE.7020404@arm.com>
References: <1391098262-15944-1-git-send-email-ian.campbell@citrix.com>
	<201401301828.59294.arnd@arndb.de>
	<52EA8CFE.7020404@arm.com>
Date: Fri, 31 Jan 2014 11:48:06 -0600
Message-ID: <CAL_JsqJeka0KeejY4LpGFd7hfYo_OKnnH8QWjSXkcgedvA6BZg@mail.gmail.com>
Subject: Re: [PATCH] arm: document "mach-virt" platform.
From: Rob Herring <robherring2@gmail.com>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Will Deacon <Will.Deacon@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>, Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 30, 2014 at 11:33 AM, Marc Zyngier <marc.zyngier@arm.com> wrote:
> On 30/01/14 17:28, Arnd Bergmann wrote:
>> On Thursday 30 January 2014, Ian Campbell wrote:
>>> mach-virt has existed for a while but it is not written down what it actually
>>> consists of. Although it seems a bit unusual to document a binding for an
>>> entire platform since mach-virt is entirely virtual it is helpful to have
>>> something to refer to in the absence of a single concrete implementation.
>>>
>>> I've done my best to capture the requirements based on the git log and my
>>> memory/understanding.
>>>
>>> While here remove the xenvm dts example, the Xen tools will now build a
>>> suitable mach-virt compatible dts when launching the guest.
>>
>> It might be worth noting in the changeset comment that the 'compatible'
>> string is actually no longer needed on newer kernels: All the members
>> of the machine descriptor are now the defaults (we should remove the
>> virt_init() function as well), and the fallback machine descriptor should
>> work just fine if any other string gets passed.
>
> I will ack the patch that removes the mach-virt directory altogether!

Did I never send that one out? I know I started something. Finding new
employment has had me distracted...

Rob
