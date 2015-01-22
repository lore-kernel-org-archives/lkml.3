Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282AbbAVCbU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 21:31:20 -0500
Received: from gir.skynet.ie ([193.1.99.77]:53102 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752375AbbAVCbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 21:31:11 -0500
Date: Thu, 22 Jan 2015 02:31:06 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Goz <ben.goz@amd.com>, Oded Gabbay <oded.gabbay@amd.com>
Subject: Re: linux-next: manual merge of the drm tree with Linus' tree
In-Reply-To: <20150122132249.28ffba12@canb.auug.org.au>
Message-ID: <alpine.DEB.2.00.1501220230380.12580@skynet.skynet.ie>
References: <20150122132249.28ffba12@canb.auug.org.au>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Hi Dave,
> 
> Today's linux-next merge of the drm tree got a conflict in
> drivers/gpu/drm/radeon/radeon_kfd.c between commit b64b8afcca9d
> ("drm/amd: Fixing typos in kfd<->kgd interface") from Linus'  tree and
> commit a84a9903b588 ("drm/radeon: Implement SDMA interface functions")
> from the drm tree.

btw I pushed a drm-next with all these fixed in it a little while ago

we must be racing!
Dave.
