Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935357AbaKNMmX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 07:42:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60260 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934994AbaKNMmW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 07:42:22 -0500
Message-ID: <5465F8AC.1050905@suse.com>
Date: Fri, 14 Nov 2014 13:42:20 +0100
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [Xen-devel] [PATCH V3 7/8] xen: switch to linear virtual mapped
 sparse p2m list
References: <1415684626-18590-1-git-send-email-jgross@suse.com>	<1415684626-18590-8-git-send-email-jgross@suse.com>	<54624BCB.9040300@citrix.com> <546477FD.9050800@suse.com> <5465EE4E.2010206@citrix.com>
In-Reply-To: <5465EE4E.2010206@citrix.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2014 12:58 PM, David Vrabel wrote:
> On 13/11/14 09:21, Juergen Gross wrote:
>> On 11/11/2014 06:47 PM, David Vrabel wrote:
>>>
>>> Can you please test this with the following guests/scenarios.
>>>
>>> * 64 bit dom0 with PCI devices with high MMIO BARs.
>>
>> I'm not sure I have a machine available with this configuration.
>
> We have a bunch of them in our test lab. Unfortunately, xapi doesn't
> work on Linux 3.12 or later so I won't be able to test this series in
> the short term.

I've found one. Stay tuned. :-)


Juergen

