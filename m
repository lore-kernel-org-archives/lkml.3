Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513Ab3DSKBh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 06:01:37 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:45152 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783Ab3DSKBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 06:01:35 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH V2 1/7] kbuild: create an "include chroot" for DT bindings
To: Stephen Warren <swarren@wwwdotorg.org>, Michal Marek <mmarek@suse.cz>,
        Grant Likely <glikely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>
Cc: arm@kernel.org, Shawn Guo <shawn.guo@linaro.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>, linux-kbuild@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>
In-Reply-To: <1365032098-22825-1-git-send-email-swarren@wwwdotorg.org>
References: <1365032098-22825-1-git-send-email-swarren@wwwdotorg.org>
Date: Fri, 19 Apr 2013 11:01:32 +0100
Message-Id: <20130419100132.72DD23E116D@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  3 Apr 2013 17:34:52 -0600, Stephen Warren <swarren@wwwdotorg.org> wrote:
> Grant, Rob, Michal, I'm hoping for acks or comments from you so this
> series can be placed into a topic branch in the arm-soc repo, for others
> to build on during the 3.10 kernel cycle. Thanks.

Thanks for doing all this work Stephen. It looks really good.

g.
