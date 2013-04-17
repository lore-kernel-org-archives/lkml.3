Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758619Ab3DQThN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 15:37:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58158 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758463Ab3DQThM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 15:37:12 -0400
Message-ID: <516EF9DE.6000707@zytor.com>
Date: Wed, 17 Apr 2013 12:37:02 -0700
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
References: <1366224198-49485-1-git-send-email-holt@sgi.com> <1366224198-49485-6-git-send-email-holt@sgi.com>
In-Reply-To: <1366224198-49485-6-git-send-email-holt@sgi.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2013 11:43 AM, Robin Holt wrote:
> Moving the reboot=s<##> parameter for x86 to a kernel parameter
> proper.  I did not find any other arch that was specifying the
> reboot cpu.
> 
> I left a compatibility mode in there.  The new parameter always
> takes precedence.  I also fixed up the current code to support
> up to cpuid's up to the current max of 4096.
> 

I still don't understand why you insist on introducing a new parameter
rather than just supporting the existing, somewhat ugly, syntax: it is
rare enough to need that the compatibility wins over the aestetics.

Furthermore that word "cpuid" that you keep using, I don't think it
means what you think it means...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

