Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330AbaKCRqU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 12:46:20 -0500
Received: from smtp01.online.nl ([194.134.41.31]:35427 "EHLO smtp01.online.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752905AbaKCRqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 12:46:17 -0500
X-Greylist: delayed 482 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Nov 2014 12:46:17 EST
Message-ID: <5457BD85.2070901@topic.nl>
Date: Mon, 03 Nov 2014 18:38:13 +0100
From: Mike Looijmans <mike.looijmans@topic.nl>
Organization: Topic
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: lgirdwood@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Add ltc3562 voltage regulator driver
References: <1414570560-10320-2-git-send-email-mike.looijmans@topic.nl> <1414668415-597-1-git-send-email-mike.looijmans@topic.nl> <20141030165133.GB18557@sirena.org.uk> <54573860.4060708@topic.nl> <20141103120919.GE3815@sirena.org.uk> <545795D8.1040600@topic.nl> <20141103151058.GP3815@sirena.org.uk>
In-Reply-To: <20141103151058.GP3815@sirena.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Online-Scanned: by Cloudmark authority (on smtp01.online.nl)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3-11-2014 16:10, Mark Brown wrote:
> On Mon, Nov 03, 2014 at 03:48:56PM +0100, Mike Looijmans wrote:
>> ﻿On 11/03/2014 01:09 PM, Mark Brown wrote:
>
>>> No function calls, just use regulators_node.  What is unclear about the
>>> functionality?
>
>> I don't understand what you mean by "regulators_node".
>
>> "grep -R regulators_node *" in the kernel source tree returns no results,
>> nor does http://lxr.free-electrons.com/ident?i=regulators_node
>
> You need to develop against current versions of the kernel, this is
> something that was merged into Linus' tree during the merge window.

Is this an absolute show-stopper for you?

With some effort I could move from our current 3.15 to 3.17, but even 
that wouldn't be recent enough then. I can justify spending a few days 
on getting the driver integrated into mainline, even if the initial 
version cost less than that; but moving everything to mainline is going 
to take weeks and the boss is definitely going to say "no" to that.

-- 
Mike Looijmans
