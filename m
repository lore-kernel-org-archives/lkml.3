Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916Ab3LJRJe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 12:09:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49299 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752717Ab3LJRJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 12:09:33 -0500
Message-ID: <52A74AAE.70804@zytor.com>
Date: Tue, 10 Dec 2013 09:09:02 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-kernel@vger.kernel.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/2] x86, microcode: Do Intel microcode revision check
 signed
References: <1386363843-32530-1-git-send-email-andi@firstfloor.org> <20131210153000.GA3804@phenom.dumpdata.com> <20131210155533.GI21717@two.firstfloor.org>
In-Reply-To: <20131210155533.GI21717@two.firstfloor.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2013 07:55 AM, Andi Kleen wrote:
> On Tue, Dec 10, 2013 at 10:30:00AM -0500, Konrad Rzeszutek Wilk wrote:
>> On Fri, Dec 06, 2013 at 01:04:02PM -0800, Andi Kleen wrote:
>>> From: Andi Kleen <ak@linux.intel.com>
>>>
>>> The Intel SDM Vol 3 9.11.1 Microcode update states that
>>> the update revision field is signed. However we do the comparison
>>> unsigned, as the comparison gets promoted.
>>>
>>> Use a cast to really do a signed comparison of the microcode
>>> revision.
>>
>> Why not just update the struct?
> 
> It would need updating various printks I think. So I chose the simpler cast,
> as that already solves the comparison problem.
> 
> -Andi
> 

Updating the printks sounds like the right thing, too.

	-hpa

