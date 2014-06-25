Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724AbaFYKwD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 06:52:03 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:50373 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756209AbaFYKwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 06:52:00 -0400
Message-ID: <53AAA9BF.4090205@oracle.com>
Date: Wed, 25 Jun 2014 20:51:43 +1000
From: James Morris <james.l.morris@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Paul Moore <paul@paul-moore.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: linux-next: the selinux tree needs cleaning up
References: <20140618084046.1bce12cc@canb.auug.org.au> <20140620085931.6427678d@canb.auug.org.au> <1474416.aEfMv8Ny53@sifl> <32647147.KmAPzBrbMT@sifl> <20140625095928.3161ebe1@canb.auug.org.au>
In-Reply-To: <20140625095928.3161ebe1@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2014 09:59 AM, Stephen Rothwell wrote:
> Hi Paul,
>
> On Tue, 24 Jun 2014 14:03:08 -0400 Paul Moore <paul@paul-moore.com> wrote:
>>
>> On Friday, June 20, 2014 12:06:28 PM Paul Moore wrote:
>>
>> {big snip}
>>
>>> Stephen, assuming for a moment that I created a fresh branch, based against
>>> 3.15, and then added the SELinux patches for 3.16 (basically the few new
>>> patches that were in the ole #next branch) would that serve as a reasonable
>>> basis for a new SELinux #next branch?  Around the -rc5/6/7 timeframe I would
>>> send a pull request to James to pull from this next branch into the Linux
>>> Security branch for 3.17.  Once 3.16 is released, I would merge that into
>>> this new #next branch and continue with the next round of patches.
>>>
>>> FYI, more or less, the above is the process we've settled upon for all of
>>> the trees that get accumulated into the Linux Security tree.
>>
>> Does the above work for you in linux-next?  I'd like to try and resolve this
>> sooner rather than later and I imagine you feel the same ...
>
> Well, I see that James has pulled your tree, so past problems are now
> moot. He has some duplicate commits in his tree now and Linus will get
> a few more when he next pulls James' tree.  We just need to avoid this
> going forward.  And given that James or Serge will, from now on, *pull*
> your tree (not cherry-pick from it), things should be fine.
>

I haven't pulled in Paul's tree, I merged with the latest Linus release.
