Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759502Ab3GZS15 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 14:27:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:63918 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752282Ab3GZS14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 14:27:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,752,1367996400"; 
   d="scan'208";a="371850091"
Message-ID: <51F2BF8C.7010308@linux.intel.com>
Date: Fri, 26 Jul 2013 11:27:24 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Jeremy Eder <jeder@redhat.com>, linux-kernel@vger.kernel.org,
        rafael.j.wysocki@intel.com, youquan.song@intel.com,
        paulmck@linux.vnet.ibm.com, daniel.lezcano@linaro.org,
        len.brown@intel.com
Subject: Re: RFC:  revert request for cpuidle patches e11538d1 and 69a37bea
References: <20130726173306.GB17985@jeder.rdu.redhat.com> <51F2BC31.7000407@redhat.com>
In-Reply-To: <51F2BC31.7000407@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/26/2013 11:13 AM, Rik van Riel wrote:

>
> Could you try running the tests with just the repeat mode
> stuff from commit 69a37bea excluded, but leaving the common
> infrastructure and commit e11538?
>

personally I think we should go the other way around.
revert the set entirely first, and now, and get our performance back
to what it should be

and then see what we can add back without causing the regressions.
this may take longer, or be done in steps, and that's ok.

the end point may well be the same... but we can then evaluate in the right
direction.
