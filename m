Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757034AbaFYNa2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 09:30:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:45404 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754567AbaFYNa1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 09:30:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,546,1400050800"; 
   d="scan'208";a="563213595"
Message-ID: <1403703004.20275.21.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] sysctl: Add a feature to drop caches selectively
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Thomas Knauth <thomas.knauth@gmx.de>
Cc: David Rientjes <rientjes@google.com>,
        Maksym Planeta <mcsim.planeta@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 25 Jun 2014 16:30:04 +0300
In-Reply-To: <CABhLV02COaH=qP=Snd7YJtcVOvm9NTmY58QuiTQoPZxH3NemPQ@mail.gmail.com>
References: <1403626213-7691-1-git-send-email-mcsim.planeta@gmail.com>
	 <alpine.DEB.2.02.1406241458140.29176@chino.kir.corp.google.com>
	 <1403677528.7903.103.camel@sauron.fi.intel.com>
	 <CABhLV03_PNFiwsvt+yitcsKxz5TeVECCFavdNkbgQ+XzQqASaw@mail.gmail.com>
	 <1403690184.20275.11.camel@sauron.fi.intel.com>
	 <CABhLV02COaH=qP=Snd7YJtcVOvm9NTmY58QuiTQoPZxH3NemPQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-25 at 15:23 +0200, Thomas Knauth wrote:
> On Wed, Jun 25, 2014 at 11:56 AM, Artem Bityutskiy <dedekind1@gmail.com> wrote:
> > Thanks for the answer, although you forgot to comment on the question
> > about possibly extending the new interface to work with file ranges in
> > the future. For example, I have a 2 TiB file, and I am only interested
> > in dropping caches for the first couple of gigabytes. Would I extend
> > your interface, or would I come up with another one?
> 
> Ah, didn't quite understand what was meant with file ranges. Again, we
> had not considered this so far. I guess you could make a distinction
> between directories and files here. If the path points to a file, you
> can have an optional argument indicating the range of bytes you would
> like to drop. Something like
> 
> echo "my-file 0-1000,8000-1000" > /proc/sys/vm/sdrop_cache
> 
> If this is desirable, we can add it to the patch.

No, I do not ask to implement this, just trying to understand how the
interface could possibly be extended.

-- 
Best Regards,
Artem Bityutskiy

