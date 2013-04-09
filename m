Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936068Ab3DICFa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 22:05:30 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:3690 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751100Ab3DICF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 22:05:29 -0400
X-IronPort-AV: E=Sophos;i="4.87,435,1363104000"; 
   d="scan'208";a="7018126"
Message-ID: <516377CF.2080004@cn.fujitsu.com>
Date: Tue, 09 Apr 2013 10:07:11 +0800
From: Lin Feng <linfeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "cl@linux.com" <cl@linux.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "arnd@arndb.de" <arnd@arndb.de>, "tony@atomide.com" <tony@atomide.com>,
        "ben@decadent.org.uk" <ben@decadent.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "isimatu.yasuaki@jp.fujitsu.com" <isimatu.yasuaki@jp.fujitsu.com>
Subject: Re: [PATCH 2/2] mm: vmemmap: arm64: add vmemmap_verify check for
 hot-add node case
References: <1365415000-10389-1-git-send-email-linfeng@cn.fujitsu.com> <1365415000-10389-3-git-send-email-linfeng@cn.fujitsu.com> <20130408105556.GB17476@mudshark.cambridge.arm.com>
In-Reply-To: <20130408105556.GB17476@mudshark.cambridge.arm.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/09 10:04:15,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/09 10:04:19,
	Serialize complete at 2013/04/09 10:04:19
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi will,

On 04/08/2013 06:55 PM, Will Deacon wrote:
> Given that we don't have NUMA support or memory-hotplug on arm64 yet, I'm
> not sure that this change makes much sense at the moment. early_pfn_to_nid
> will always return 0 and we only ever have one node.
> 
> To be honest, I'm not sure what that vmemmap_verify check is trying to
> achieve anyway. ia64 does some funky node affinity initialisation early on
> but, for the rest of us, it looks like we always just check the distance
> from node 0.

Sorry for my noise to arm people.

Yes, not everyone cares about vmemmap_verify(), as you described it's not
necessary to arm64 at all. 

thanks,
linfeng
