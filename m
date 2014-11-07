Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982AbaKGOJ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 09:09:57 -0500
Received: from smtp.citrix.com ([66.165.176.89]:45818 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752620AbaKGOJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 09:09:52 -0500
X-IronPort-AV: E=Sophos;i="5.07,332,1413244800"; 
   d="scan'208";a="189135000"
Message-ID: <545CD26E.8040404@citrix.com>
Date: Fri, 7 Nov 2014 14:08:46 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Juergen Gross <jgross@suse.com>, David Vrabel <david.vrabel@citrix.com>,
        <linux-kernel@vger.kernel.org>, <xen-devel@lists.xensource.com>,
        <konrad.wilk@oracle.com>, <boris.ostrovsky@oracle.com>,
        <x86@kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <hpa@zytor.com>
Subject: Re: [Xen-devel] [PATCH V2 2/5] xen: Delay m2p_override initialization
References: <1415252853-7106-1-git-send-email-jgross@suse.com>	<1415252853-7106-3-git-send-email-jgross@suse.com>	<545CC349.8020006@citrix.com> <545CC6D8.80100@suse.com>
In-Reply-To: <545CC6D8.80100@suse.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/14 13:19, Juergen Gross wrote:
> On 11/07/2014 02:04 PM, David Vrabel wrote:
>>
>> I suppose this is the "make some functions static" but it's an
>> unreviewable mess.  If you can't do this with some one line changes
>> adding "static" and perhaps some forward declarations then please drop
>> this bit.
> 
> Do you really prefer forward declarations instead of pure code movement?
> I can do as you request, but just want to make sure.

Normally I prefer not having forward declarations...  How about a patch
that does this and then a 2nd patch that does the pure code motion.
Maybe that will produce a better diff?

You can also try the --patience option for git diff (etc.).  This may
produce more readable diffs.

David
