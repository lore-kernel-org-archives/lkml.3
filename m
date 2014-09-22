Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496AbaIVQXX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 12:23:23 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:48786 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189AbaIVQXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 12:23:21 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Mon, 22 Sep 2014 18:20:50 +0200
From: Johan Hovold <johan@kernel.org>
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: Johan Hovold <johan@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, lkml <linux-kernel@vger.kernel.org>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH] mfd: viperboard: allocate I/O buffer separately
Message-ID: <20140922162050.GL5237@localhost>
References: <1411397212-31625-1-git-send-email-octavian.purdila@intel.com>
 <20140922160844.GK5237@localhost>
 <CAE1zotJiLDWYThHL4DUpsnqm+C2anf1ri_Wr6+4kq5rn8YjDag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE1zotJiLDWYThHL4DUpsnqm+C2anf1ri_Wr6+4kq5rn8YjDag@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 07:19:37PM +0300, Octavian Purdila wrote:
> On Mon, Sep 22, 2014 at 7:08 PM, Johan Hovold <johan@kernel.org> wrote:
> > On Mon, Sep 22, 2014 at 05:46:52PM +0300, Octavian Purdila wrote:

> > Don't mix fixes and clean ups like this, but rather submit them as
> > separate patches.
> >
> Fair enough. Is it OK to send all of the cleanups in a single separate
> patch?

In this case, I'd say so. But do the clean-ups on top of the minimal fix
to facilitate back-porting if someone ever decides that that is needed.

Johan
