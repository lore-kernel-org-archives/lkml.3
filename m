Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050Ab3CGAeo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 19:34:44 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:59458 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754955Ab3CGAem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 19:34:42 -0500
Message-ID: <5137E09E.1060006@wwwdotorg.org>
Date: Wed, 06 Mar 2013 17:34:38 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
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
References: <1362616141-13947-1-git-send-email-swarren@wwwdotorg.org>  <1362616141-13947-3-git-send-email-swarren@wwwdotorg.org> <1362616252.2093.37.camel@joe-AO722>
In-Reply-To: <1362616252.2093.37.camel@joe-AO722>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2013 05:30 PM, Joe Perches wrote:
> On Wed, 2013-03-06 at 17:29 -0700, Stephen Warren wrote:
>> From: Stephen Warren <swarren@nvidia.com>
>>
>> This reverts most of eb90d08 "get_maintainer: allow keywords to match
>> filenames"; all except the parts that are required to implement the new
>> N: entry type.
> 
> Just combine patches 1 and 3 into a single patch.

That would break bisectability; using MAINTAINERS after applying a
squashed 1+3 but without patch 2 applied would not operate as desired.

