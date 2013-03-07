Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688Ab3CGGrb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 01:47:31 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:33038 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab3CGGra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 01:47:30 -0500
Message-ID: <51383800.7000608@wwwdotorg.org>
Date: Wed, 06 Mar 2013 23:47:28 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        Lucas Stach <dev@lynxeye.de>, Borislav Petkov <bp@alien8.de>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        linux-tegra@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH V2 3/3] get_maintainer: prevent keywords from matching
 filenames
References: <1362616141-13947-1-git-send-email-swarren@wwwdotorg.org>  <1362616141-13947-3-git-send-email-swarren@wwwdotorg.org>  <1362616252.2093.37.camel@joe-AO722> <5137E09E.1060006@wwwdotorg.org> <1362616810.2093.40.camel@joe-AO722>
In-Reply-To: <1362616810.2093.40.camel@joe-AO722>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2013 05:40 PM, Joe Perches wrote:
> On Wed, 2013-03-06 at 17:34 -0700, Stephen Warren wrote:
>> On 03/06/2013 05:30 PM, Joe Perches wrote:
>>> On Wed, 2013-03-06 at 17:29 -0700, Stephen Warren wrote:
>>>> From: Stephen Warren <swarren@nvidia.com>
>>>>
>>>> This reverts most of eb90d08 "get_maintainer: allow keywords to match
>>>> filenames"; all except the parts that are required to implement the new
>>>> N: entry type.
>>>
>>> Just combine patches 1 and 3 into a single patch.
>>
>> That would break bisectability; using MAINTAINERS after applying a
>> squashed 1+3 but without patch 2 applied would not operate as desired.
> 
> <smile>
> 
> Which is why I showed the whole thing in a single patch.
> No worries if it's simply to increase the patch count...

I'm not sure what showed refers to?

I guess if I squashed /everything/ into a single commit (i.e. the change
to the Tegra section in MAINTAINERS too) then there wouldn't be any
bisect issues. I really don't care about patch count. The reason for >1
patch is that there's often push-back if doing logically separate things
(adding N: feature, modifying a MAINTAINERS entry to use it, removing
part of K: feature) in a single patch...
