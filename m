Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932833Ab3BLAI4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 19:08:56 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:40489 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760679Ab3BLAIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 19:08:47 -0500
Message-ID: <5119880C.8010602@wwwdotorg.org>
Date: Mon, 11 Feb 2013 17:08:44 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: arm@kernel.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Julian Andres Klode <jak@jak-linux.org>,
        Marc Dietrich <marvin24@gmx.de>, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH V3 1/2] get_maintainer: allow keywords to match filenames
References: <1360626016-23332-1-git-send-email-swarren@wwwdotorg.org> <1360627226.4707.6.camel@joe-AO722>
In-Reply-To: <1360627226.4707.6.camel@joe-AO722>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2013 05:00 PM, Joe Perches wrote:
> On Mon, 2013-02-11 at 16:40 -0700, Stephen Warren wrote:
>> From: Stephen Warren <swarren@nvidia.com>
>>
>> Allow K: entries in MAINTAINERS to match directly against filenames;
>> either those extracted from patch +++ or --- lines, or those specified
>> on the command-line using the -f option.
> []
>> I don't think setting exact_pattern_match_hash would be appropriate here;
>> at least for intended Tegra use case, this feature is to ensure that all
>> Tegra-related driver changes get Cc'd to the Tegra mailing list. Setting
>> exact_pattern_match_hash would prevent git history parsing for e.g. S-o-b
>> tags, which still seems like it would be useful. Hence, this flag isn't
>> set.
> 
> And I don't think that's necessary because for filenames,
> you could add the appropriate control to the MAINTAINERS
> 
> "K:	^pattern$"

Does "that" above mean "not setting exact_pattern_match_hash", or
"changing the patch so that it does set exact_pattern_match_hash". Sorry...
