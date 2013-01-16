Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758456Ab3APEcq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 23:32:46 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:33830 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757147Ab3APEco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 23:32:44 -0500
Message-ID: <50F62D69.8080100@nvidia.com>
Date: Tue, 15 Jan 2013 21:32:41 -0700
From: Stephen Warren <swarren@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Tony Prisk <linux@prisktech.co.nz>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: linux-next: manual merge of the tegra tree with the arm-soc tree
References: <20130116141411.8fadedee54ed35dc0eddd288@canb.auug.org.au> <1358308153.32106.8.camel@gitbox>
In-Reply-To: <1358308153.32106.8.camel@gitbox>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2013 08:49 PM, Tony Prisk wrote:
> On Wed, 2013-01-16 at 14:14 +1100, Stephen Rothwell wrote:
>> Hi all,
>>
>> Today's linux-next merge of the tegra tree got a conflict in
>> drivers/clocksource/Makefile between commit ff7ec345f0ec ("timer: vt8500:
>> Move timer code to drivers/clocksource") from the arm-soc tree and commit
>> ac0fd9eca3ba ("ARM: tegra: move timer.c to drivers/clocksource/") from
>> the tegra tree.
>>
>> I fixed it up (see below) and can carry the fix as necessary (no action
>> is required).
>>
> 
> I don't know about everyone else, but I feel the preference should be to
> keep things alphabetized where possible to help avoid with merge
> conflicts later on. This is always a problem when we start tacking
> things on the end of lists.
> 
> I realise this Kconfig is not alphabetized anyway, but it's never too
> early to start on the 'right' path.

Sounds like a good idea, but the issue is: When to do the initial sort
so it doesn't conflict with all the adds in a kernel cycle... Post and
immediately commit a new patch near the end of the merge window?

