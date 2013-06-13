Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751015Ab3FMEA0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 00:00:26 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:47223 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705Ab3FMEAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 00:00:25 -0400
Date: Wed, 12 Jun 2013 21:00:19 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH percpu/for-3.11 2/2] percpu-refcount: implement
 percpu_ref_cancel_init()
Message-ID: <20130613040019.GG10979@localhost>
References: <20130613035201.GD9451@mtj.dyndns.org>
 <20130613035235.GE9451@mtj.dyndns.org>
 <20130613035636.GF10979@localhost>
 <20130613035831.GF9451@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130613035831.GF9451@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 08:58:31PM -0700, Tejun Heo wrote:
> At first I named it percpu_ref_free() but it looked too symmetric to
> init, more so than kill, so I was worried that people might get
> confused that this is the normal interface to shutdown a percpu
> refcnt, so the weird cancel_init name and further restriction on its
> usage.

...Yeah, confusion with _kill() is a good point. Ok, cancel_init() it
is.
