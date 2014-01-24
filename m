Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773AbaAXAFO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 19:05:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:32840 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752323AbaAXAFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 19:05:12 -0500
Message-ID: <52E1AE28.9050007@zytor.com>
Date: Thu, 23 Jan 2014 16:04:56 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Mark Brown <broonie@kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>
Subject: Re: [GIT PULL] regulator updates for v3.13-rc1
References: <20131125174037.GR14725@sirena.org.uk>	<CA+55aFwPcr8TYpLUg5NP9x3RGCv4+U7vz-nNH6Br5ku3MDwaDw@mail.gmail.com>	<20131126003919.GT14725@sirena.org.uk> <CA+55aFxX3odNLBt1L6iAPGybekioqaW3SREmXywd_jnz_tDBeQ@mail.gmail.com>
In-Reply-To: <CA+55aFxX3odNLBt1L6iAPGybekioqaW3SREmXywd_jnz_tDBeQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2014 11:16 AM, Linus Torvalds wrote:
> On Mon, Nov 25, 2013 at 4:39 PM, Mark Brown <broonie@kernel.org> wrote:
>>
>> If you're OK with octopus merges for things like this I'll definitely
>> take another look at using them, the enormous stack of merge commits
>> always looks noisy to me in the logs and pull requests and for things
>> like driver updates there's unlikely to be much doubt about which branch
>> it was if there's a problem.
> 
> Christ. When you start doing octopus merges, you don't do it by half
> measures, do you?
> 
> I just pulled the sound updates from Takashi, and as a result got your
> merge commit 2cde51fbd0f3. That one has 66 parents.
> 

For sheer amusement value: the tip-bot uses a private git tree to keep
track of what it has mailed and not mailed.  At least once it produced a
243-input octopus merge.

	-hpa


