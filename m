Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117AbaCGXMD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 18:12:03 -0500
Received: from mga03.intel.com ([143.182.124.21]:61239 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753283AbaCGXMC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 18:12:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,610,1389772800"; 
   d="scan'208";a="488217631"
Message-ID: <531A5240.4070108@linux.intel.com>
Date: Fri, 07 Mar 2014 15:12:00 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Stefani Seibold <stefani@seibold.net>,
        Fengguang Wu <fengguang.wu@intel.com>
CC: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [x86, vdso]  BUG: unable to handle kernel paging request at d34bd000
References: <20140307013833.GD8427@localhost>	 <1394182034.21684.6.camel@wall-e.seibold.net>	 <20140307091515.GA8888@localhost>	 <1394186248.28066.42.camel@wall-e.seibold.net>	 <20140307102107.GA21656@localhost> <1394208388.1012.2.camel@wall-e.seibold.net>
In-Reply-To: <1394208388.1012.2.camel@wall-e.seibold.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2014 08:06 AM, Stefani Seibold wrote:
>>
>> wfg@bee /tmp% git clone --reference /c/linux git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git
> 
> As i wrote i already cloned the tip tree!!!!!!
> 
> But i cannot see the changeset, there is also no VDSO changes set in the
> git log.
> 

It isn't on the master branch because it hasn't been stable enough to merge.

You need to do:

	git checkout x86/vdso

	-hpa


