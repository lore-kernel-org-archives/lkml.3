Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852AbaCXLe6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 07:34:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:30323 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752325AbaCXLe5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 07:34:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,720,1389772800"; 
   d="scan'208";a="506278328"
Message-ID: <53301A90.6050803@linux.intel.com>
Date: Mon, 24 Mar 2014 13:44:16 +0200
From: Mathias Nyman <mathias.nyman@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: David Cohen <david.a.cohen@linux.intel.com>
CC: Felipe Balbi <balbi@ti.com>, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] usb/xhci: fix compilation warning when !CONFIG_PCI
 && !CONFIG_PM
References: <1389059068-18491-1-git-send-email-david.a.cohen@linux.intel.com> <1389063739-6028-1-git-send-email-david.a.cohen@linux.intel.com> <20140218180030.GA10029@psi-dev26.jf.intel.com> <20140218184741.GI28506@saruman.home> <20140218190412.GA32402@psi-dev26.jf.intel.com> <20140321214123.GB10097@psi-dev26.jf.intel.com>
In-Reply-To: <20140321214123.GB10097@psi-dev26.jf.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2014 11:41 PM, David Cohen wrote:
> Hi Mathias,
>
>>
>> Thanks for commenting. That would be actually the v1 of my patch :)
>> I changed after I see the proper function has __maybe_unused flag.
>>
>> But I'm fine with Sarah picking any of the patch's versions.
>
> Guess you're handling the review of this trivial patch now :)
> Comments are very welcome.
>
> Br, David
>

Hi

Patch version 1 inlining the stubs looks good to me. I'll queue it for 
Greg’s usb-linus once 3.15-rc1 is out.

-Mathias

