Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218AbaJFUi0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 16:38:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32780 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089AbaJFUiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 16:38:25 -0400
Date: Mon, 6 Oct 2014 22:38:23 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, Tom Gundersen <teg@jklm.no>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Davidlohr Bueso <dbueso@suse.de>, Takashi Iwai <tiwai@suse.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Werner Fink <werner@suse.de>, linux-kernel@vger.kernel.org,
        Ewan Milne <emilne@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Santosh Rastapur <santosh@chelsio.com>, Petr Mladek <pmladek@suse.cz>,
        Robert Milasan <rmilasan@suse.com>, Hannes Reinecke <hare@suse.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Coccinelle <cocci@systeme.lip6.fr>, Jean Delvare <jdelvare@suse.de>,
        Benjamin Poirier <bpoirier@suse.de>
Subject: Re: [Cocci] [PATCH v2 2/7] module: add extra argument for
	parse_params() callback
Message-ID: <20141006203823.GB14081@wotan.suse.de>
References: <1412372683-2003-1-git-send-email-mcgrof@do-not-panic.com> <1412372683-2003-3-git-send-email-mcgrof@do-not-panic.com> <542FEE4A.4040401@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <542FEE4A.4040401@users.sourceforge.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 04, 2014 at 02:55:38PM +0200, SF Markus Elfring wrote:
> > This adds an extra argument onto parse_params() to be used
> > as a way to make the unused callback a bit more useful and
> > generic by allowing the caller to pass on a data structure
> > of its choice.
> 
> How do you think about to work with more data type definitions for such callback
> functions?

Sorry I don't understand what you mean.

  Luis
