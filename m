Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936234Ab3DQB7q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 21:59:46 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:47800 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936188Ab3DQB7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 21:59:44 -0400
Date: Tue, 16 Apr 2013 18:55:41 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Rhyland Klein <rklein@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH V2 2/3] power: power_supply: Add core support for
 supplied_from
Message-ID: <20130417015541.GC18418@lizard.mcd26095.sjc.wayport.net>
References: <1364852755-17425-1-git-send-email-rklein@nvidia.com>
 <1364852755-17425-3-git-send-email-rklein@nvidia.com>
 <515B4E32.8080006@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <515B4E32.8080006@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 02, 2013 at 03:31:30PM -0600, Stephen Warren wrote:
> On 04/01/2013 03:45 PM, Rhyland Klein wrote:
> > This patch adds support for supplies to register a list of char *'s
> > which represent the list of supplies which supply them. This is the
> > opposite as the supplied_to list.
> 
> This patch resolves the concerns I had before, so,
> Reviewed-by: Stephen Warren <swarren@nvidia.com>

Thanks a lot for the work, folks! With some fixes (see comments for patch
3/3), this is now in battery-2.6.git tree.

Anton
