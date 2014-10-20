Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166AbaJTUhW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 16:37:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37862 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688AbaJTUhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 16:37:18 -0400
Date: Mon, 20 Oct 2014 22:37:14 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, gregkh@linuxfoundation.org,
        dmitry.torokhov@gmail.com, tiwai@suse.de, tj@kernel.org,
        arjan@linux.intel.com, teg@jklm.no, rmilasan@suse.com, werner@suse.com,
        oleg@redhat.com, hare@suse.com, bpoirier@suse.de, santosh@chelsio.com,
        pmladek@suse.cz, dbueso@suse.com, linux-kernel@vger.kernel.org,
        Jani Nikula <jani.nikula@intel.com>
Subject: Re: [PATCH v2 1/7] taint: add TAINT_DEBUG for invasive debugging
	features
Message-ID: <20141020203714.GO28966@wotan.suse.de>
References: <1412372683-2003-1-git-send-email-mcgrof@do-not-panic.com> <1412372683-2003-2-git-send-email-mcgrof@do-not-panic.com> <87d29tc2ut.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d29tc2ut.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 04:05:06PM +1030, Rusty Russell wrote:
> "Luis R. Rodriguez" <mcgrof@do-not-panic.com> writes:
> > From: "Luis R. Rodriguez" <mcgrof@suse.com>
> >
> > At times we may add module parameters or debugging / testing
> > kernel features, when enabled though we don't really want
> > to be spending time debugging them. Add a taint flag for
> > this to avoid spurious bug reports.
> 
> The recently introduced KERNEL_PARAM_FL_UNSAFE flag for module
> parameters does this explicitly.  It uses TAINT_USER, should it use
> this instead?

Absolutely, dropped my taint thing in favor of this, thanks.

 Luis
