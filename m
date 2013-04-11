Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304Ab3DKURF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:17:05 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:32917 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153Ab3DKURA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:17:00 -0400
Message-ID: <51671A39.6090105@gmail.com>
Date: Thu, 11 Apr 2013 15:16:57 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 0/4 v6] arm: introduce psci_smp_ops and use them on Xen
References: <alpine.DEB.2.02.1304031239550.5078@kaball.uk.xensource.com> <alpine.DEB.2.02.1304081102500.5353@kaball.uk.xensource.com> <20130411082519.GD31465@quad.lixom.net>
In-Reply-To: <20130411082519.GD31465@quad.lixom.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2013 03:25 AM, Olof Johansson wrote:
> On Mon, Apr 08, 2013 at 12:05:17PM +0100, Stefano Stabellini wrote:
>> Arnd, Olof,
>> do you have any thoughts on this series?
>> Would you be happy to carry it in the arm-soc tree?
>>
>> The last patch, "xen/arm: introduce xen_early_init, use PSCI on xen" has
>> a (small) dependency on this series:
>>
>> http://marc.info/?l=linux-kernel&m=136430893610688&w=2
>>
>> would you be OK with taking that one too, or should that go through the
>> Xen tree?
> 
> I think it'd make sense to get Russell to ack the changes to the core ARM code.
> We can merge the series through arm-soc, or he can take them, whatever is
> easiest for everybody.
> 
> Given the dependencies on the second branch it might be easier to merge
> through Russell's tree.

I'm also dependent on the 1st patch for converting highbank to use PSCI
and am just waiting on a stable branch to base it on. I believe Russell
said he is offline for the next week.

Rob


