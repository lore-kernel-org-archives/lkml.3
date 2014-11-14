Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935168AbaKNL6L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 06:58:11 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:2952 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933262AbaKNL6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 06:58:09 -0500
X-IronPort-AV: E=Sophos;i="5.07,385,1413244800"; 
   d="scan'208";a="192816416"
Message-ID: <5465EE4E.2010206@citrix.com>
Date: Fri, 14 Nov 2014 11:58:06 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Juergen Gross <jgross@suse.com>, David Vrabel <david.vrabel@citrix.com>,
        <linux-kernel@vger.kernel.org>, <xen-devel@lists.xensource.com>,
        <konrad.wilk@oracle.com>, <boris.ostrovsky@oracle.com>,
        <x86@kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <hpa@zytor.com>
Subject: Re: [Xen-devel] [PATCH V3 7/8] xen: switch to linear virtual mapped
 sparse p2m list
References: <1415684626-18590-1-git-send-email-jgross@suse.com>	<1415684626-18590-8-git-send-email-jgross@suse.com>	<54624BCB.9040300@citrix.com> <546477FD.9050800@suse.com>
In-Reply-To: <546477FD.9050800@suse.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/11/14 09:21, Juergen Gross wrote:
> On 11/11/2014 06:47 PM, David Vrabel wrote:
>>
>> Can you please test this with the following guests/scenarios.
>>
>> * 64 bit dom0 with PCI devices with high MMIO BARs.
> 
> I'm not sure I have a machine available with this configuration.

We have a bunch of them in our test lab. Unfortunately, xapi doesn't
work on Linux 3.12 or later so I won't be able to test this series in
the short term.

David


