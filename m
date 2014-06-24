Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289AbaFXAcc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 20:32:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59987 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754120AbaFXAcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 20:32:31 -0400
Date: Tue, 24 Jun 2014 02:32:29 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: netdev@vger.kernel.org, cocci@systeme.lip6.fr,
        linux-kernel@vger.kernel.org
Subject: Re: [Cocci] SmPL for automatic request_firmware_nowait() conversion
Message-ID: <20140624003229.GE27687@wotan.suse.de>
References: <20140621015714.GX4841@wotan.suse.de> <20140621105205.GA31611@electric-eye.fr.zoreil.com> <20140623232107.GB27687@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140623232107.GB27687@wotan.suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 01:21:07AM +0200, Luis R. Rodriguez wrote:
> On Sat, Jun 21, 2014 at 12:52:05PM +0200, Francois Romieu wrote:
> > Luis R. Rodriguez <mcgrof@suse.com> :
> I was actually in the hopes a suitable transormation can be designed
> to put a wait_for_completion() in say ndo_init(). I was looking to
> see if a tranformation can be generalized of course if the above
> observations on probe() is something desirable to be addressed.

And a really cool check would be to transform all those non fatal
request_firmware() calls to request_firmware_direct().

  Luis
