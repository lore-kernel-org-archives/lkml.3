Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758795Ab3BLKEc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 05:04:32 -0500
Received: from mga01.intel.com ([192.55.52.88]:10239 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754602Ab3BLKEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 05:04:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,648,1355126400"; 
   d="scan'208";a="286083854"
Date: Tue, 12 Feb 2013 11:04:24 +0100
From: Samuel Ortiz <samuel.ortiz@intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Jean-Nicolas Graux <jean-nicolas.graux@stericsson.com>,
        linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH] mfd: support stmpe1801 18 bits enhanced port expander
Message-ID: <20130212100424.GA1403@sortiz-mobl>
References: <1355993839-12479-1-git-send-email-jean-nicolas.graux@stericsson.com>
 <CACRpkdZ4rK9t7qV_TFcZDDh9-1CL6LGrjuYapfRnPOa7YQWjEg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdZ4rK9t7qV_TFcZDDh9-1CL6LGrjuYapfRnPOa7YQWjEg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Mon, Feb 11, 2013 at 02:58:44PM +0100, Linus Walleij wrote:
> On Thu, Dec 20, 2012 at 9:57 AM, Jean-Nicolas Graux
> <jean-nicolas.graux@stericsson.com> wrote:
> 
> > Provides support for 1801 variant of stmpe gpio port expanders.
> > This chip has 18 gpios configurable as GPI, GPO, keypad matrix,
> > special key or dedicated key function.
> >
> > Note that special/dedicated key function is not supported yet.
> >
> > Signed-off-by: Jean-Nicolas Graux <jean-nicolas.graux@stericsson.com>
> 
> Sam, did you accidentally miss this patch?
I did, because it was sent to my @intel.com address (as opposed to my
@linux.intel.com one).

> It's been around for a while...
And it's still missing an ACK from Dmitry, who was not cc'ed in the first
place.
I'll add him to the list and see if he's fine with the input parts as it's the
biggest part of this patch.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
---------------------------------------------------------------------
Intel Corporation SAS (French simplified joint stock company)
Registered headquarters: "Les Montalets"- 2, rue de Paris, 
92196 Meudon Cedex, France
Registration Number:  302 456 199 R.C.S. NANTERRE
Capital: 4,572,000 Euros

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

