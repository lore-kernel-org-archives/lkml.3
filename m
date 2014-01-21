Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751773AbaAUGDw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 01:03:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38271 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaAUGDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 01:03:47 -0500
Date: Mon, 20 Jan 2014 22:04:28 -0800
From: Greg Kroah-Hartmann <gregkh@linuxfoundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patch 1/2] mm, memcg: avoid oom notification when current needs
 access to memory reserves
Message-ID: <20140121060428.GA19037@kroah.com>
References: <20140109144757.e95616b4280c049b22743a15@linux-foundation.org>
 <alpine.DEB.2.02.1401091551390.20263@chino.kir.corp.google.com>
 <20140109161246.57ea590f00ea5b61fdbf5f11@linux-foundation.org>
 <alpine.DEB.2.02.1401091613560.22649@chino.kir.corp.google.com>
 <20140110221432.GD6963@cmpxchg.org>
 <alpine.DEB.2.02.1401121404530.20999@chino.kir.corp.google.com>
 <20140115143449.GN8782@dhcp22.suse.cz>
 <alpine.DEB.2.02.1401151319580.10727@chino.kir.corp.google.com>
 <20140116093220.GC28157@dhcp22.suse.cz>
 <alpine.DEB.2.02.1401202155410.21729@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1401202155410.21729@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 09:58:28PM -0800, David Rientjes wrote:
> The patches getting proposed through -mm for stable boggles my mind
> sometimes.

Do you have any objections to patches that I have taken for -stable?  If
so, please let me know.

thanks,

greg k-h
