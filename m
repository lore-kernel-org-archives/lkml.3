Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633AbaAQU1u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 15:27:50 -0500
Received: from mga02.intel.com ([134.134.136.20]:7306 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752899AbaAQU1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 15:27:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,675,1384329600"; 
   d="scan'208";a="468458866"
From: Andi Kleen <andi@firstfloor.org>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: "Dorau\, Lukasz" <lukasz.dorau@intel.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi\@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        sebastian.riemer@profitbricks.com, richard.weinberger@gmail.com
Subject: Re: Why is (2 < 2) true? Is it a gcc bug?
References: <D9FFE20C522965449E182ACE73889AEB1A6A340F@IRSMSX105.ger.corp.intel.com>
	<CAADnVQLUP=7oxciVw97d76xtqs6_YjC6E2boPRO9y4m_sqjRCA@mail.gmail.com>
	<CAADnVQL=s8zc_ACSuPs8P3y-RB9Td8OZysM=0fj4sjzUPRzfGw@mail.gmail.com>
Date: Fri, 17 Jan 2014 12:27:47 -0800
In-Reply-To: <CAADnVQL=s8zc_ACSuPs8P3y-RB9Td8OZysM=0fj4sjzUPRzfGw@mail.gmail.com>
	(Alexei Starovoitov's message of "Fri, 17 Jan 2014 11:58:28 -0800")
Message-ID: <878uue1hh8.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>
> disable Value Range Propagation pass:
> -fdisable-tree-vrp1 -fdisable-tree-vrp2
>
> and complete unroll pass:
> -fdisable-tree-cunrolli

Can you file a gcc bug with test case?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
