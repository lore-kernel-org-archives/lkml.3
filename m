Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758261Ab3CTQma (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 12:42:30 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:49167 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066Ab3CTQm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 12:42:29 -0400
Message-ID: <5149E6F2.5070205@wwwdotorg.org>
Date: Wed, 20 Mar 2013 10:42:26 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Laxman Dewangan <ldewangan@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "lrg@ti.com" <lrg@ti.com>
Subject: Re: [PATCH 2/2] regulator: palmas: add input supply names
References: <1363598989-25112-1-git-send-email-ldewangan@nvidia.com> <20130320123128.GM28775@opensource.wolfsonmicro.com> <5149B19E.90400@nvidia.com> <5149DEB5.7000709@wwwdotorg.org> <20130320163833.GT28775@opensource.wolfsonmicro.com>
In-Reply-To: <20130320163833.GT28775@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2013 10:38 AM, Mark Brown wrote:
> On Wed, Mar 20, 2013 at 10:07:17AM -0600, Stephen Warren wrote:
>> On 03/20/2013 06:54 AM, Laxman Dewangan wrote:
> 
>>> I generally send a patches on single git-send command git
>>> send-emal --to=ldewangan@nvidia.com 0000.patch 0001.patch
> 
>> Don't do that; send *.patch. If you don't, then patches 2..n
>> don't end up being "in-reply-to" patch 1, so they won't show up
>> as a single email thread.
> 
> The two should be equivalent (though the glob is much easier to
> type)? The result of the globbing ought to be what Laxman is typing
> by hand assuming that he's getting the order correct.

If you send *.patch at once, git send-email adds an in-reply-to header
to the email which sets up the threading. If you send the patches
1-by-1, this header isn't added, since git send-email doesn't have a
clue what message ID it chose for patch 1. Unless you pass the
--in-reply-to command-line option, that is.
