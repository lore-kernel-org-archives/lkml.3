Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751447AbaKEW6z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 17:58:55 -0500
Received: from mga11.intel.com ([192.55.52.93]:3597 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbaKEW6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 17:58:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,322,1413270000"; 
   d="scan'208";a="627292760"
From: Andi Kleen <andi@firstfloor.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Masanari Iida <standby24x7@gmail.com>, Jonathan Corbet <corbet@lwn.net>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, lcapitulino@redhat.com
Subject: Re: [PATCH] Documentation: vm: Add 1GB large page support information
References: <1414771317-5721-1-git-send-email-standby24x7@gmail.com>
	<5457C6EA.3080809@intel.com>
	<CALLJCT0fofgUaswpzt1iBqGS1u+fR8L=umwGpV=RG0SvO9TOJA@mail.gmail.com>
	<545A42C4.6070908@intel.com>
Date: Wed, 05 Nov 2014 14:58:51 -0800
In-Reply-To: <545A42C4.6070908@intel.com> (Dave Hansen's message of "Wed, 05
	Nov 2014 07:31:16 -0800")
Message-ID: <871tphtftg.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen <dave.hansen@intel.com> writes:

> On 11/05/2014 07:21 AM, Masanari Iida wrote:
>> Luiz, Dave,
>> Thanks for comments.
>> 
>> I understand that there are some exception cases which doesn't support 1G
>> large pages on newer CPUs.
>> I like Dave's example, at the same time I would like to add "pdpe1gb flag" in
>> the document.
>> 
>> For example, x86 CPUs normally support 4K and 2M (1G if pdpe1gb flag exist).
>
> Is 1G supported on CPUs that have pdpe1gb and are running a 32-bit kernel?

No, 1GB pages is a 64bit only feature.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
