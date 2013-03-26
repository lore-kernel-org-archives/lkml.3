Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934743Ab3CZQd6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 12:33:58 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:53771 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934635Ab3CZQd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 12:33:56 -0400
Date: Tue, 26 Mar 2013 09:33:51 -0700
From: Tejun Heo <tj@kernel.org>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Jeff Layton <jlayton@redhat.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
        skinsbursky@parallels.com, ebiederm@xmission.com, jmorris@namei.org,
        axboe@kernel.dk
Subject: Re: [PATCHSET] idr: implement idr_alloc() and convert existing users
Message-ID: <20130326163351.GB3061@htj.dyndns.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
 <20130203170241.GA24778@fieldses.org>
 <20130204001557.GB24778@fieldses.org>
 <20130204171031.GK27963@mtj.dyndns.org>
 <20130204171128.GL27963@mtj.dyndns.org>
 <20130321140618.GD27838@fieldses.org>
 <20130321183513.GC20500@htj.dyndns.org>
 <20130326111936.550110bf@tlielax.poochiereds.net>
 <20130326152653.GA3061@htj.dyndns.org>
 <20130326163011.GC3353@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130326163011.GC3353@fieldses.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Mar 26, 2013 at 12:30:11PM -0400, J. Bruce Fields wrote:
> The only requirements are that at a given moment in time id's should be
> unique, and that we should make some effort to avoid reusing them
> immediately.
> 
> I don't know what other "cyclic" idr users need.

We already have other users and idr would at least behave better
(ie. fail faster) under extreme conditions, so sticking with idr might
not be too bad.  The optimal would be bitmap + hashtable, I suppose.

Thanks.

-- 
tejun
