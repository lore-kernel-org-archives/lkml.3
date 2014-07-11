Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814AbaGKQYb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 12:24:31 -0400
Received: from mail-qg0-f49.google.com ([209.85.192.49]:63474 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915AbaGKQYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 12:24:30 -0400
Date: Fri, 11 Jul 2014 12:24:25 -0400
From: Jerome Glisse <j.glisse@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Oded Gabbay <oded.gabbay@gmail.com>, David Airlie <airlied@linux.ie>,
        Alex Deucher <alexander.deucher@amd.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Oded Gabbay <oded.gabbay@amd.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Subject: Re: [PATCH 04/83] drm/radeon: Add radeon <--> kfd interface
Message-ID: <20140711162424.GE1870@gmail.com>
References: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
 <1405029027-6085-3-git-send-email-oded.gabbay@amd.com>
 <1405031913.2796.7.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1405031913.2796.7.camel@joe-AO725>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 03:38:33PM -0700, Joe Perches wrote:
> On Fri, 2014-07-11 at 00:50 +0300, Oded Gabbay wrote:
> > This patch adds the interface between the radeon driver and the kfd
> > driver. The interface implementation is contained in
> > radeon_kfd.c and radeon_kfd.h.
> []
> >  include/linux/radeon_kfd.h          | 67 ++++++++++++++++++++++++++
> 
> Is there a good reason to put this file in include/linux?
> 

Agrees, we do not want to clutter include/linux/ with specific driver
include, i think its one of the rules even thought there is some hw header
already in there.

I would rather see either a new dir include/hsa or inside include/drm.

Cheers,
Jérôme
