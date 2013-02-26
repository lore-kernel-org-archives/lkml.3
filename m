Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758412Ab3BZH5X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 02:57:23 -0500
Received: from mail-ea0-f179.google.com ([209.85.215.179]:50449 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865Ab3BZH5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 02:57:21 -0500
From: Jack Morgenstein <jackm@dev.mellanox.co.il>
Organization: Mellanox
To: Roland Dreier <roland@kernel.org>
Subject: Re: [PATCH v2] IB/mlx4: silence GCC warning
Date: Tue, 26 Feb 2013 09:57:04 +0200
User-Agent: KMail/1.9.1
Cc: Paul Bolle <pebolle@tiscali.nl>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
References: <1348836538.3626.21.camel@x61.thuisdomein> <CAL1RGDWVAYCTNOOA+s_n5Pu7JgrR-6K+krcbSuARtEhgze_nqw@mail.gmail.com> <CAL1RGDWt2cgcwec-iQ9f8-YvC8fO2AncGBfQ2VUgPi3W49bKxg@mail.gmail.com>
In-Reply-To: <CAL1RGDWt2cgcwec-iQ9f8-YvC8fO2AncGBfQ2VUgPi3W49bKxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201302260957.04585.jackm@dev.mellanox.co.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 February 2013 19:23, Roland Dreier wrote:
> On Mon, Feb 25, 2013 at 8:54 AM, Roland Dreier <roland@kernel.org> wrote:
> > I'm finally noticing that this is in the build_mlx_header() function,
> > which is pretty much a slow path.  Certainly another compare isn't
> > going to change performance given all the other stuff we do there.
> >
> > Let me look at the patches that have gone by and see what the cleanest
> > way to handle this is.
> 
> OK, after playing around a bit, I see that just initializing vlan
> doesn't really change the generated code (my gcc at least was already
> if effect setting vlan in the generated assembly code), so I'll just
> merge that.
> 
>  - R.

Thanks!

-Jack 
