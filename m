Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935680Ab3DHSt7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 14:49:59 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:48282 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935303Ab3DHSt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 14:49:56 -0400
Date: Mon, 8 Apr 2013 11:49:51 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Li Zefan <lizefan@huawei.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, bsingharora@gmail.com,
        Kay Sievers <kay.sievers@vrfy.org>, lpoetter@redhat.com,
        linux-kernel@vger.kernel.org, dhaval.giani@gmail.com,
        workman-devel@redhat.com
Subject: Re: [Workman-devel] cgroup: status-quo and userland efforts
Message-ID: <20130408184951.GK3021@htj.dyndns.org>
References: <20130406012159.GA17159@mtj.dyndns.org>
 <20130408175925.GE28292@redhat.com>
 <20130408181607.GI3021@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130408181607.GI3021@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08, 2013 at 11:16:07AM -0700, Tejun Heo wrote:
> > Given the fact that library has view of full system resoruces (both
> > persistent view and active view), shouldn't we just be able to extend
> > the API to meet additional configuration or resource needs.
> 
> Maybe, I don't know.  It just looks like a weird approach to me.
> Wouldn't it make more sense to implement it as a dbus service that
> everyone talks to?  That's how our base system is structured these
> days.  Why should this be any different?

To expand a bit, the base system being composed that way makes a lot
of sense.  It becomes clear who's responsible for what and there's a
reliable way to recover when things go awry on the clients' sides.
Also, it pretty much *forces* you to design an interface which fits
the problem domain properly rather than exposing all the control knobs
there are without thinking how they'd be actually useful.  The
language binding issue is much easier too - it's already solved.

It seems like the only logical thing to do, well, at least to me.
Am I missing something?

Thanks.

-- 
tejun
