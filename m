Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758832Ab3FMSJc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 14:09:32 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:46053 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088Ab3FMSJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 14:09:31 -0400
Date: Thu, 13 Jun 2013 11:09:24 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH percpu/for-3.11 2/2] percpu-refcount: implement
 percpu_ref_cancel_init()
Message-ID: <20130613180924.GA12075@mtj.dyndns.org>
References: <20130613035201.GD9451@mtj.dyndns.org>
 <20130613035235.GE9451@mtj.dyndns.org>
 <20130613035636.GF10979@localhost>
 <20130613035831.GF9451@mtj.dyndns.org>
 <20130613040019.GG10979@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130613040019.GG10979@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 09:00:19PM -0700, Kent Overstreet wrote:
> On Wed, Jun 12, 2013 at 08:58:31PM -0700, Tejun Heo wrote:
> > At first I named it percpu_ref_free() but it looked too symmetric to
> > init, more so than kill, so I was worried that people might get
> > confused that this is the normal interface to shutdown a percpu
> > refcnt, so the weird cancel_init name and further restriction on its
> > usage.
> 
> ...Yeah, confusion with _kill() is a good point. Ok, cancel_init() it
> is.

Applied both patches to percpu/for-3.11.  Added a paragraph explaining
the weird naming and usage restriction just in case.

Thanks.

-- 
tejun
