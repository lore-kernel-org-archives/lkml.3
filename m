Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490Ab3EaWVr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 18:21:47 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:55957 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757372Ab3EaWVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 18:21:30 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] kbuild: make sure we clean up DTB temporary files
To: Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Stephen Warren <swarren@nvidia.com>,
        Rob Herring <rob.herring@calxeda.com>, linux-kbuild@vger.kernel.org
In-Reply-To: <51A8DD74.8090403@wwwdotorg.org>
References: <1369995261-20735-1-git-send-email-ian.campbell@citrix.com> <51A8DD74.8090403@wwwdotorg.org>
Date: Fri, 31 May 2013 23:21:25 +0100
Message-Id: <20130531222125.D228E3E08FE@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 May 2013 11:27:16 -0600, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 05/31/2013 04:14 AM, Ian Campbell wrote:
> > Various temporary files used when building DTB files were not suffixed with
> > .tmp and therefore were not cleaned up by "make clean".
> 
> Reviewed-by: Stephen Warren <swarren@nvidia.com>
> Tested-by: Stephen Warren <swarren@nvidia.com>

Merged, thanks.

g.

