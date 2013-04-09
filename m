Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936893Ab3DIHRQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 03:17:16 -0400
Received: from mga03.intel.com ([143.182.124.21]:40805 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934419Ab3DIHRP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 03:17:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,436,1363158000"; 
   d="scan'208";a="283522551"
Date: Tue, 9 Apr 2013 09:17:11 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 1/9] mfd: Add commands abstraction layer for SI476X MFD
Message-ID: <20130409071711.GB23447@zurbaran>
References: <1364352446-28572-1-git-send-email-andrew.smirnov@gmail.com>
 <1364352446-28572-2-git-send-email-andrew.smirnov@gmail.com>
 <20130408101624.GR24058@zurbaran>
 <CAHQ1cqE4aokZA98VfCWwRtkaNPm6dMnegibVz4BHfYW_VrAUBA@mail.gmail.com>
 <20130408200946.GA23447@zurbaran>
 <CAHQ1cqGytarQ9bkOiq-MdpRbKiHBTRPJy90Cbg=Sr4J7MWNj+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHQ1cqGytarQ9bkOiq-MdpRbKiHBTRPJy90Cbg=Sr4J7MWNj+g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08, 2013 at 01:40:40PM -0700, Andrey Smirnov wrote:
> On Mon, Apr 8, 2013 at 1:09 PM, Samuel Ortiz <sameo@linux.intel.com> wrote:
> > On Mon, Apr 08, 2013 at 11:34:43AM -0700, Andrey Smirnov wrote:
> > > On Mon, Apr 8, 2013 at 3:16 AM, Samuel Ortiz <sameo@linux.intel.com>
> > wrote:
> > > > This file doesn't exist yet, which breaks bisectability.
> > > > I'm fine with you including it with the first patch. I will prepare a
> > > branch
> > > > with the mfd patches from your serie for Mauro to pull from.
> > > >
> > >
> > > It was initially one single patch(in v1), and I split it in three upon
> > > Hans' request(for ease of reviewing).
> > It probably made sense then, but now, as I said, it breaks bisectability.
> > So
> > I'd appreciate if you could add this header file to this first patch so
> > that I
> > can merge the MFD parts independently.
> > Again, I will provide a branch for Mauro to pull from and apply the
> > remaining
> > patches on top of it.
> >
> >
> OK, I will squash the commits and make another version of the patches.
The separation of the patches as it is now looks good to me. But you need to
add the media header to the first MFD patches, no need to squash commits
together.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
