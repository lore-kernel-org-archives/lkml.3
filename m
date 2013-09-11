Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800Ab3IKII0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 04:08:26 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:38881 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265Ab3IKIIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 04:08:24 -0400
Date: Wed, 11 Sep 2013 10:59:44 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Chris Brannon <chris@the-brannons.com>
Cc: devel@driverdev.osuosl.org, Kirk Reiser <kirk@reisers.ca>,
        Raphael S Carvalho <raphael.scarv@gmail.com>, speakup@braille.uwo.ca,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH 1/1] staging/speakup/kobjects.c: Code improvement.
Message-ID: <20130911075944.GA25896@mwanda>
References: <1378160418-13898-1-git-send-email-raphael.scarv@gmail.com>
 <87fvtefy10.fsf@mushroom.PK5001Z>
 <CACz=WeeE+jxdaxpR_amF60deDcEy8nChYYfY3UA3CNfhmOB8Gw@mail.gmail.com>
 <87y576edm6.fsf@mushroom.PK5001Z>
 <20130910231228.GF6329@mwanda>
 <878uz4du2k.fsf@mushroom.PK5001Z>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878uz4du2k.fsf@mushroom.PK5001Z>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 06:29:39PM -0700, Chris Brannon wrote:
> Ok.  I just sent up a patch to the driverdev list.  I missed a few
> of the Cc's that were on this thread, though.
> Also, it will conflict with Raphael's cleanup.

You're missing Raphael's CC in particular...

Really, Raphael's patch arrived first.  No one seems to have any
objections to his patch.  Normally apply it first and then apply this
one.  If we decide to push this one to -stable then we would redo it (in
other words push the one you just sent).

Of course, the merge window is open right now so nothing is going to be
applied for a couple weeks.

regards,
dan carpenter

