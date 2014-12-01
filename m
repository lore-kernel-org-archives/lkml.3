Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330AbaLALB1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 06:01:27 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:58401 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185AbaLALBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 06:01:24 -0500
X-IronPort-AV: E=Sophos;i="5.07,493,1413244800"; 
   d="scan'208";a="198344998"
Message-ID: <547C4A7E.6020207@citrix.com>
Date: Mon, 1 Dec 2014 11:01:18 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Juergen Gross <jgross@suse.com>, Andrew Cooper <andrew.cooper3@citrix.com>,
        "Luis R. Rodriguez" <mcgrof@suse.com>
CC: <x86@kernel.org>, <kvm@vger.kernel.org>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        <linux-kernel@vger.kernel.org>, Davidlohr Bueso <dbueso@suse.de>,
        Joerg Roedel <jroedel@suse.de>, Jan Beulich <JBeulich@suse.com>,
        <xen-devel@lists.xenproject.org>, <boris.ostrovsky@oracle.com>,
        Borislav Petkov <bp@suse.de>, Olaf Hering <ohering@suse.de>
Subject: Re: [Xen-devel] [PATCH] xen: privcmd: schedule() after private hypercall
 when	non CONFIG_PREEMPT
References: <1417040805-15857-1-git-send-email-mcgrof@do-not-panic.com>	<5476C66F.5040308@suse.com> <20141127183616.GV25677@wotan.suse.de> <54777277.5040401@citrix.com> <5477FECF.2060404@suse.com>
In-Reply-To: <5477FECF.2060404@suse.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/11/14 04:49, Juergen Gross wrote:
> On 11/27/2014 07:50 PM, Andrew Cooper wrote:
>> 
>> XenServer uses
>>
>> https://github.com/xenserver/linux-3.x.pg/blob/master/master/0001-x86-xen-allow-privcmd-hypercalls-to-be-preempted.patch
>>
>>
>> to deal with these issues.  That patch is based on 3.10.
> 
> Clever. :-)
> 
>>
>> I can remember whether this has been submitted upstream before (and
>> there were outstanding issues), or whether it fell at an inconvenient
>> time with our development cycles.
> 
> I found
> 
> http://lists.xen.org/archives/html/xen-devel/2014-02/msg02540.html
> 
> and nothing else.

I dropped it because it copy-and-paste a bunch of otherwise generic x86
assembler and looked unlikely to get an x86 maintainer ack.  If you
think otherwise, feel free to pick it up and run with it.

David
