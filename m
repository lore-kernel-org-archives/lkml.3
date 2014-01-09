Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757642AbaAIAHt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 19:07:49 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:48246 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757266AbaAIAHq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 19:07:46 -0500
X-Originating-IP: 50.43.14.201
Date: Wed, 8 Jan 2014 16:07:35 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Rashika Kheria <rashika.kheria@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Maling list - DRI developers 
	<dri-devel@lists.freedesktop.org>,
        Jerome Glisse <jglisse@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Subject: Re: [PATCH 22/85] drivers: gpu: Mark functions as static in
 radeon_device.c
Message-ID: <20140109000735.GA23891@leaf>
References: <b21c9d47bbb72f2134540b852c908a2080f1ed1d.1389018324.git.rashika.kheria@gmail.com>
 <8af55c93ab10b11d473f9c731eddd6710ae7a418.1389018324.git.rashika.kheria@gmail.com>
 <CADnq5_OrzQ+Jr0G6pzLq99ivA7WEc2dnEmY6S3y6FKWwXZ09TA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CADnq5_OrzQ+Jr0G6pzLq99ivA7WEc2dnEmY6S3y6FKWwXZ09TA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 11:40:28AM -0500, Alex Deucher wrote:
> On Mon, Jan 6, 2014 at 10:21 AM, Rashika Kheria
> <rashika.kheria@gmail.com> wrote:
> > Mark functions radeon_doorbell_init() and radeon_doorbell_fini() as
> > static in drm/radeon/radeon_device.c because they are not used outside
> > this file.
> >
> > This eliminates the following warning in drm/radeon/radeon_device.c:
> > drivers/gpu/drm/radeon/radeon_device.c:252:5: warning: no previous prototype for ‘radeon_doorbell_init’ [-Wmissing-prototypes]
> > drivers/gpu/drm/radeon/radeon_device.c:281:6: warning: no previous prototype for ‘radeon_doorbell_fini’ [-Wmissing-prototypes]
> >
> > Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> > Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> 
> I've pulled in a subset of these patches:
> http://cgit.freedesktop.org/~agd5f/linux/log/?h=drm-next-3.14-wip
> I held off on some of the others as I'd rather fix up the headers
> properly rather than just cramming everything in radeon.h or
> radeon-asic.h for now.

Can you elaborate on which patches are putting functions in the wrong
header, and what header you'd prefer to see them in?

- Josh Triplett
