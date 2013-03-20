Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757718Ab3CTQHW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 12:07:22 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:46975 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808Ab3CTQHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 12:07:20 -0400
Message-ID: <5149DEB5.7000709@wwwdotorg.org>
Date: Wed, 20 Mar 2013 10:07:17 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "lrg@ti.com" <lrg@ti.com>
Subject: Re: [PATCH 2/2] regulator: palmas: add input supply names
References: <1363598989-25112-1-git-send-email-ldewangan@nvidia.com> <20130320123128.GM28775@opensource.wolfsonmicro.com> <5149B19E.90400@nvidia.com>
In-Reply-To: <5149B19E.90400@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2013 06:54 AM, Laxman Dewangan wrote:
> On Wednesday 20 March 2013 06:01 PM, Mark Brown wrote:
>> * PGP Signed by an unknown key
>>
>> On Mon, Mar 18, 2013 at 02:59:48PM +0530, Laxman Dewangan wrote:
>>
>> There's something odd about several recent patch serieses you've posted,
>> they end up with patch 2 before instead of after patch 1.  Anyway...
> 
> I generally send a patches on single git-send command
> git send-emal --to=ldewangan@nvidia.com 0000.patch 0001.patch

Don't do that; send *.patch. If you don't, then patches 2..n don't end
up being "in-reply-to" patch 1, so they won't show up as a single email
thread.
