Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab3GHGid (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 02:38:33 -0400
Received: from mga14.intel.com ([143.182.124.37]:49611 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753422Ab3GHGib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 02:38:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1016,1363158000"; 
   d="scan'208";a="328038237"
Message-ID: <51DA5E65.5060006@linux.intel.com>
Date: Mon, 08 Jul 2013 09:38:29 +0300
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT] Networking
References: <20130707.132133.1335860703202153192.davem@davemloft.net> <CA+55aFzgBXwye=ebPmEDN_6yqdKA6ZaD9hSUzbFjSacC_v3y5g@mail.gmail.com> <CA+55aFyvZAQbaEyq5atQbTjHTz_hodzhWKX_7SRL8nq+yBA14A@mail.gmail.com> <20130707.201449.1176672898198722699.davem@davemloft.net>
In-Reply-To: <20130707.201449.1176672898198722699.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2013 06:14, David Miller wrote:
> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Sun, 7 Jul 2013 15:33:31 -0700
>
>> End result: I think the code is salvageable and people who want this
>> kind of busy-looping can have it. But I really don't want to merge it
>> as-is. I think it was badly done, I think it was badly documented, and
>> I think somebody over-sold the feature by emphasizing the upsides and
>> not the problems.
>
> Fair enough, Eliezer, please address all of Linus's feedback.
>
> It's holding the entire net-next merge up.
>

OK


