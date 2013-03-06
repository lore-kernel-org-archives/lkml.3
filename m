Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264Ab3CFTb4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 14:31:56 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:51314 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab3CFTbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 14:31:55 -0500
Message-ID: <513799A5.3010609@wwwdotorg.org>
Date: Wed, 06 Mar 2013 12:31:49 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Marcin Slusarz <marcin.slusarz@gmail.com>
CC: Stephen Warren <swarren@nvidia.com>, Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Lucas Stach <dev@lynxeye.de>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        nouveau@lists.freedesktop.org,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>
Subject: Re: nouveau lockdep splat
References: <20130304211608.GD22274@pd.tnic> <1362501052.1933.2.camel@antimon> <20130306000429.GA30189@pd.tnic> <20130306191418.GA3400@joi.lan>
In-Reply-To: <20130306191418.GA3400@joi.lan>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2013 12:14 PM, Marcin Slusarz wrote:
> On Wed, Mar 06, 2013 at 01:04:29AM +0100, Borislav Petkov wrote:
>> On Tue, Mar 05, 2013 at 05:30:52PM +0100, Lucas Stach wrote:
>>> Dropping Tegra ML, it's not the place where Nouveau mails should go.
>>
>> $ ./scripts/get_maintainer.pl -f drivers/gpu/drm/nouveau/nv50_display.c
>> ...
>> linux-tegra@vger.kernel.org (open list:TEGRA SUPPORT)
>>
>> Maybe get_maintainer.pl patterns need correction...
> 
> That's new feature (introduced in commit eb90d0855b75f8 "get_maintainer: allow
> keywords to match filenames") of get_maintainer.pl which now can look at file
> contents...

get_maintainer.pl could always look at file contents IIRC. The change
was that I added keyword "tegra" to the Tegra section that now matches
this file's contents.

./scripts/get_maintainer.pl -f drivers/gpu/drm/nouveau

... might be a better invocation, although perhaps I should add an
explicit exclusion for "nouveau" to the Tegra section in MAINTAINERS.
