Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996AbaDSWnK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 18:43:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52696 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270AbaDSWnB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 18:43:01 -0400
Message-ID: <5352FBC8.7030704@zytor.com>
Date: Sat, 19 Apr 2014 15:42:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>, Ingo Molnar <mingo@kernel.org>
CC: Leif Lindholm <leif.lindholm@linaro.org>, Roy Franz <roy.franz@linaro.org>,
        Mark Salter <msalter@redhat.com>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] EFI changes for v3.16
References: <20140419100653.GA26088@console-pimps.org>
In-Reply-To: <20140419100653.GA26088@console-pimps.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2014 03:06 AM, Matt Fleming wrote:
> Hi folks,
> 
> Please pull the following changes for v3.16. I'd like to get these in
> early so that they've got plenty of time to bake in linux-next. In
> particular, the ARM folks have had a hard time getting the generic EFI
> cleanups/improvements picked up via other trees.
> 
> Obviously by taking these through tip we're creating a dependency with
> whatever tree the ARM patches live in. Do we need to inform Stephen
> Rothwell explicitly of this dependency? How should we handle things when
> the v3.16 merge window opens?
> 

It doesn't hurt to inform Stephen, although I think it will simply fall
out automatically since he uses git to merge and git will recognize the
graph.

During the merge window, it means they should not push their patches
until Linus has accepted the precondition patches from the tip tree.
Since Ingo and I try to push most of the tip tree as early as possible
in the merge window, this is usually not a problem.

	-hpa

