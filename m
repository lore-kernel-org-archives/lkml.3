Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932246Ab3DWQG6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 12:06:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:45105 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932117Ab3DWQGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 12:06:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,534,1363158000"; 
   d="scan'208";a="323074703"
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        <kosaki.motohiro@gmail.com>, <mingo@kernel.org>, <hpa@zytor.com>,
        <srivatsa.bhat@linux.vnet.ibm.com>, <linux-kernel@vger.kernel.org>,
        <x86@kernel.org>, <linux-mm@kvack.org>
Subject: Re: [Bug fix PATCH v2] numa, cpu hotplug: Change links of CPU and node when changing node number by onlining CPU
References: <5170D4CB.20900@jp.fujitsu.com>
	<20130422153541.04ba682f13910cfede0d2ff7@linux-foundation.org>
Date: Tue, 23 Apr 2013 09:06:55 -0700
In-Reply-To: <20130422153541.04ba682f13910cfede0d2ff7@linux-foundation.org>
	(Andrew Morton's message of "Mon, 22 Apr 2013 15:35:41 -0700")
Message-ID: <m2y5c9ut7k.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:
>
> Would it not be better to fix this by assigning those CPUs to their real,
> memoryless node right at the initial boot?  Or is there something in
> the kernel which makes cpus-on-a-memoryless-node not work correctly?

I probably added this originally. The original reason was that long
ago the VM was broken with memory less nodes. These days it is likely
obsolete.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
