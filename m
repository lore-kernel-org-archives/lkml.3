Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947545Ab3BIArX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 19:47:23 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:59105 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947333Ab3BIArW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 19:47:22 -0500
Message-ID: <51159C96.5080505@wwwdotorg.org>
Date: Fri, 08 Feb 2013 17:47:18 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: arm@kernel.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] MAINTAINERS: add keyword "tegra" to Tegra section
References: <1360353891-24210-1-git-send-email-swarren@wwwdotorg.org> <1360370419.13487.8.camel@joe-AO722>
In-Reply-To: <1360370419.13487.8.camel@joe-AO722>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2013 05:40 PM, Joe Perches wrote:
> On Fri, 2013-02-08 at 13:04 -0700, Stephen Warren wrote:
>> (?<!in)tegra
> 
> This doesn't work well.   It matches too many
> words like integral.

Hmmm. That's exactly what the (?<!in) negative look-behind assertion is
attempting to avoid. It works fine here. Is there some dependency on
Perl version or something? My Perl version is v5.14.2.

> I suggest
> 
> K:	(?:\btegra\b|\bTEGRA_)
> 

