Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292AbaLHVuJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 16:50:09 -0500
Received: from smtp-out-161.synserver.de ([212.40.185.161]:1219 "EHLO
	smtp-out-158.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753040AbaLHVuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 16:50:06 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 3253
Message-ID: <54861D04.8000102@metafoo.de>
Date: Mon, 08 Dec 2014 22:49:56 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Vinod Koul <vinod.koul@intel.com>
CC: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?windows-1252?Q?Antoine_T=E9nart?= <antoine@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH v5 00/61] dmaengine: Implement generic slave capabilities
 retrieval
References: <1416231775-31252-1-git-send-email-maxime.ripard@free-electrons.com> <20141208061746.GD16827@intel.com> <20141208141807.GC8739@lukather> <20141208162843.GP16827@intel.com> <20141208183853.GG8739@lukather>
In-Reply-To: <20141208183853.GG8739@lukather>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2014 07:38 PM, Maxime Ripard wrote:
[...]
>> And lastly noone blamed you for being late, if things were rosy they
>> would have been merged over the weekend and been in today's next,
>> but...
>
> I totally understand your point. And I actually am a bit uncomfortable
> merging this so late too, and I'd actually prefer to have it merged
> for 3.20. But this is a huge patchset, and I'd really like to avoid
> rebasing it forever.

We don't have to pull in the whole series at once. I think everybody agrees 
that the approach is the right one, so the first couple of patches that work 
on the framework should be good to go in. Same goes for the drivers that 
have been acked and tested.

- Lars
