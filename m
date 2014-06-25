Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157AbaFYKD2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 06:03:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:34169 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbaFYKD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 06:03:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,544,1400050800"; 
   d="scan'208";a="553007087"
Message-ID: <1403690595.20275.14.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] sysctl: Add a feature to drop caches selectively
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Thomas Knauth <thomas.knauth@gmx.de>
Cc: David Rientjes <rientjes@google.com>,
        Maksym Planeta <mcsim.planeta@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 25 Jun 2014 13:03:15 +0300
In-Reply-To: <CABhLV03_PNFiwsvt+yitcsKxz5TeVECCFavdNkbgQ+XzQqASaw@mail.gmail.com>
References: <1403626213-7691-1-git-send-email-mcsim.planeta@gmail.com>
	 <alpine.DEB.2.02.1406241458140.29176@chino.kir.corp.google.com>
	 <1403677528.7903.103.camel@sauron.fi.intel.com>
	 <CABhLV03_PNFiwsvt+yitcsKxz5TeVECCFavdNkbgQ+XzQqASaw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-25 at 10:25 +0200, Thomas Knauth wrote:
> On Wed, Jun 25, 2014 at 8:25 AM, Artem Bityutskiy <dedekind1@gmail.com> wrote:
> > Plus some explanations WRT why proc-based interface and what would be
> > the alternatives, what if tomorrow we want to extend the functionality
> > and drop caches only for certain file range, is this only for regular
> > files or also for directories, why posix_fadvice(DONTNEED) is not
> > sufficient.
> 
> I suggested the idea originally. Let me address each of your questions in turn:

I'd also be interested to see some analysis about path-based interface
vs. file descriptor-base interface. What are cons and pros. E.g. if my
path is a symlink, with path-based interface it is not obvious whether I
drop caches for the symlink itself or caches of the target.

Note, if there are no answers, fine with me, I am asking just out of
curiosity.

-- 
Best Regards,
Artem Bityutskiy

