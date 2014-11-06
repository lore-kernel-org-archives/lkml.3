Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074AbaKFH4K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 02:56:10 -0500
Received: from mga11.intel.com ([192.55.52.93]:53162 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991AbaKFH4G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 02:56:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,324,1413270000"; 
   d="scan'208";a="627507145"
Message-ID: <1415260542.958.161.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 03/35] UBI: Fastmap: Add self check to detect absent PEBs
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        tlinder@codeaurora.org
Date: Thu, 06 Nov 2014 09:55:42 +0200
In-Reply-To: <545A4ACA.2070402@nod.at>
References: <1414586758-9972-1-git-send-email-richard@nod.at>
			 <1414586758-9972-4-git-send-email-richard@nod.at>
		 <1415201029.958.118.camel@sauron.fi.intel.com> <545A48BD.9010904@nod.at>
	 <1415203295.958.133.camel@sauron.fi.intel.com> <545A4ACA.2070402@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-11-05 at 17:05 +0100, Richard Weinberger wrote:
> Am 05.11.2014 um 17:01 schrieb Artem Bityutskiy:
> > On Wed, 2014-11-05 at 16:56 +0100, Richard Weinberger wrote:
> >>  I did that to have alloc and free balanced.
> >> I.e. to not have a naked kfree(). Always when I see a kfree()
> >> somewhere
> >> I'd like to see the k*alloc().
> > 
> > OK. Please, just make the comment simpler then. Say that you are freeing
> > the debugging buffer or something.
> 
> Will do!

I suggest you to prepare a short series of patches and send this out. I
think I can process them faster then. When you send 35 patches I tend to
postpone the review because it looks like a a lot of work which needs a
lot of time. Small series is easier to deal with.

So instead of re-sending 35 patches, just send 3 or for good patches,
I'll pick them much faster, I think.

Artem.


