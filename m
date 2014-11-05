Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484AbaKEPba (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 10:31:30 -0500
Received: from mga14.intel.com ([192.55.52.115]:23368 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755446AbaKEPb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 10:31:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="411862172"
Message-ID: <545A42C4.6070908@intel.com>
Date: Wed, 05 Nov 2014 07:31:16 -0800
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>
CC: Jonathan Corbet <corbet@lwn.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, lcapitulino@redhat.com
Subject: Re: [PATCH] Documentation: vm: Add 1GB large page support information
References: <1414771317-5721-1-git-send-email-standby24x7@gmail.com>	<5457C6EA.3080809@intel.com> <CALLJCT0fofgUaswpzt1iBqGS1u+fR8L=umwGpV=RG0SvO9TOJA@mail.gmail.com>
In-Reply-To: <CALLJCT0fofgUaswpzt1iBqGS1u+fR8L=umwGpV=RG0SvO9TOJA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2014 07:21 AM, Masanari Iida wrote:
> Luiz, Dave,
> Thanks for comments.
> 
> I understand that there are some exception cases which doesn't support 1G
> large pages on newer CPUs.
> I like Dave's example, at the same time I would like to add "pdpe1gb flag" in
> the document.
> 
> For example, x86 CPUs normally support 4K and 2M (1G if pdpe1gb flag exist).

Is 1G supported on CPUs that have pdpe1gb and are running a 32-bit kernel?

