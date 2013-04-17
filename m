Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936232Ab3DQTz6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 15:55:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58312 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757494Ab3DQTz5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 15:55:57 -0400
Message-ID: <516EFE41.4000605@zytor.com>
Date: Wed, 17 Apr 2013 12:55:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Robin Holt <holt@sgi.com>
CC: Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Russ Anderson <rja@sgi.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH -v5 5/5] Make reboot_cpuid a kernel parameter.
References: <1366224198-49485-1-git-send-email-holt@sgi.com> <1366224198-49485-6-git-send-email-holt@sgi.com> <516EF9DE.6000707@zytor.com> <20130417194836.GK3658@sgi.com>
In-Reply-To: <20130417194836.GK3658@sgi.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2013 12:48 PM, Robin Holt wrote:
> 
> Did you see my response I sent this morning?
> 

I did not, although I just read it.

I have a hard time seeing maintaining backwards/forwards compatibility
as "very wrong" ... it would seem like a pretty major concern.  In
comparison losing the currently nonexistent /sys file seems like a
rather minor issue.

My suggestion would be to have a universal parser for reboot= and have
the arch functions fed data in already parsed form.

> I would really like to try and remove the apparently unused reboot=
> parameter from arm and unicore32 as well.  Does anybody have a concern
> with that?  That should make documenting slightly easier.

You have to ask the arm and unicore32 maintainers that, obviously.

>> Furthermore that word "cpuid" that you keep using, I don't think it
>> means what you think it means...
> 
> If we stayed with the core_param, would you prefer reboot_processor=###
> over reboot_cpuid=###?

reboot_cpu=<n>

	-hpa


