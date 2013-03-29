Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab3C2GVO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 02:21:14 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:54543
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754020Ab3C2GVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 02:21:12 -0400
X-IronPort-AV: E=Sophos;i="4.87,371,1363129200"; 
   d="scan'208";a="9128268"
Date: Fri, 29 Mar 2013 07:21:07 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
cc: Julia Lawall <julia.lawall@lip6.fr>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        florianschandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev <linux-fbdev@vger.kernel.org>,
        dri-devel@lists.freedesktop.org,
        "backports@vger.kernel.org" <backports@vger.kernel.org>,
        cocci@systeme.lip6.fr,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rodrigo.vivi" <rodrigo.vivi@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        "rafael.j.wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH] compat/compat-drivers/linux-next: fb skip_vt_switch
In-Reply-To: <CAB=NE6WX5Dv9p2jrNwe9GxfH=EUm596uvSspsLQ5-Uuonc6Fqg@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1303290720350.2023@localhost6.localdomain6>
References: <1364472270-9297-1-git-send-email-mcgrof@do-not-panic.com> <20130328083943.01e61b4b@jbarnes-desktop> <alpine.DEB.2.02.1303281718490.1928@hadrien> <CAB=NE6WbNwPqEPYsASAPaECe4qbAWdd4=eJ402ib+CzZbT69=g@mail.gmail.com> <alpine.DEB.2.02.1303281909570.1928@hadrien>
 <CAB=NE6VPRu8DvneVdwd=pXF0ngi5OifNTpZtX3pLi50i116_OA@mail.gmail.com> <alpine.DEB.2.02.1303282328200.2022@localhost6.localdomain6> <CAB=NE6WX5Dv9p2jrNwe9GxfH=EUm596uvSspsLQ5-Uuonc6Fqg@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I looked in today's linux-next, and there seems to be only one
> > initialization of this field, to true, and one test of this field.  So
> > perhaps the case for setting the field to false just isn't needed.
> 
> Oh sorry now I get what you mean! I thought about this -- and yes I
> decided to not add a bool false setting for the structure field given
> that the assumption is this would not be something dynamic, and data
> structure would be kzalloc()'d so by default they are 0.

What do you do about the test, though?

julia
