Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803Ab3IZP3o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 11:29:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:46619 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750805Ab3IZP3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 11:29:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,986,1371106800"; 
   d="scan'208";a="401430956"
Message-ID: <524452E3.6050200@linux.intel.com>
Date: Thu, 26 Sep 2013 08:29:39 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, mgorman@suse.de, dave@sr71.net,
        hannes@cmpxchg.org, tony.luck@intel.com, matthew.garrett@nebula.com,
        riel@redhat.com, srinivas.pandruvada@linux.intel.com,
        willy@linux.intel.com, kamezawa.hiroyu@jp.fujitsu.com, lenb@kernel.org,
        rjw@sisk.pl, gargankita@gmail.com, paulmck@linux.vnet.ibm.com,
        svaidy@linux.vnet.ibm.com, andi@firstfloor.org,
        isimatu.yasuaki@jp.fujitsu.com, santosh.shilimkar@ti.com,
        kosaki.motohiro@gmail.com, linux-pm@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@stericsson.com, loic.pallardy@stericsson.com,
        amit.kachhap@linaro.org, thomas.abraham@linaro.org
Subject: Re: [Results] [RFC PATCH v4 00/40] mm: Memory Power Management
References: <20130925231250.26184.31438.stgit@srivatsabhat.in.ibm.com> <52437128.7030402@linux.vnet.ibm.com> <20130925164057.6bbaf23bdc5057c42b2ab010@linux-foundation.org> <52442F6F.5020703@linux.vnet.ibm.com>
In-Reply-To: <52442F6F.5020703@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/26/2013 5:58 AM, Srivatsa S. Bhat wrote:
> Let me explain the challenge I am facing. A prototype powerpc platform that
> I work with has the capability to transition memory banks to content-preserving
> low-power states at a per-socket granularity. What that means is that we can
> get memory power savings*without*  needing to go to full-system-idle, unlike
> Intel platforms such as Sandybridge.

btw this is not a correct statement
even Sandybridge can put memory in low power states (just not self refresh) even if the system is not idle
(depending on bios settings to enable this)

