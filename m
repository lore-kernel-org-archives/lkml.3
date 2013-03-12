Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550Ab3CLPRy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 11:17:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21816 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754599Ab3CLPRw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 11:17:52 -0400
Date: Tue, 12 Mar 2013 11:17:45 -0400
From: David Teigland <teigland@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 67/77] dlm: convert to idr_alloc()
Message-ID: <20130312151745.GB7436@redhat.com>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
 <1360179649-22465-68-git-send-email-tj@kernel.org>
 <20130311192955.GA23892@redhat.com>
 <20130311202818.GN24522@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130311202818.GN24522@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 01:28:18PM -0700, Tejun Heo wrote:
> Ah, right, in preloaded section, the allocation is expected to fail
> before falling back to the preload buffer and I forgot to add
> __GFP_NOWARN to the first try.  Something like the following should
> make it go away.  Can you please test it?

Tested, and the warnings went away, thanks.
Dave
