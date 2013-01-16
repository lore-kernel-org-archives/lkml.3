Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685Ab3APRZh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 12:25:37 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:47171 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756246Ab3APRZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 12:25:20 -0500
Message-ID: <50F6E27C.50608@wwwdotorg.org>
Date: Wed, 16 Jan 2013 10:25:16 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Terje_Bergstr=F6m?= <tbergstrom@nvidia.com>
CC: Arto Merilainen <amerilainen@nvidia.com>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv5 7/8] ARM: tegra: Add board data and 2D clocks
References: <1358249182-17486-1-git-send-email-tbergstrom@nvidia.com> <1358249182-17486-8-git-send-email-tbergstrom@nvidia.com> <50F5A3A6.7000801@wwwdotorg.org> <50F66061.20509@nvidia.com>
In-Reply-To: <50F66061.20509@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2013 01:10 AM, Terje Bergström wrote:
> On 15.01.2013 20:44, Stephen Warren wrote:
>> On 01/15/2013 04:26 AM, Terje Bergstrom wrote:
>>> Add a driver alias gr2d for Tegra 2D device, and assign a duplicate
>>> of 2D clock to that driver alias.
>>
>> FYI on this one patch - it won't be applied to the Tegra tree until
>> after Prashant's common clock framework changes are applied. As such, it
>> will need some rework once those patches are applied, or perhaps won't
>> even be relevant any more; see below.
> 
> It looks like I need to just drop the patch 7(8 "ARM: tegra: Add board
> data and 2D clocks" and change the 2D code to access the clock without a
> name. Do you agree?

That sounds right to me, yes.
