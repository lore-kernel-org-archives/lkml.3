Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932168AbaIIGAI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 02:00:08 -0400
Received: from plane.gmane.org ([80.91.229.3]:54127 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752434AbaIIGAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 02:00:06 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Ted Percival <ted@tedp.id.au>
Subject: Re: [PATCH] percpu: Resolve ambiguities in =?utf-8?b?X19nZXRfY3B1X3Zhci9jcHVtYXNrX3Zhcl90?= -fix
Date: Tue, 9 Sep 2014 05:55:15 +0000 (UTC)
Message-ID: <loom.20140909T074606-26@post.gmane.org>
References: <20140908220654.GO17501@suse.de> <alpine.DEB.2.11.1409081846340.869@gentwo.org> <20140909003450.GA11623@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 76.27.34.2 (Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.94 Safari/537.36)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj <at> kernel.org> writes:
> On Mon, Sep 08, 2014 at 06:46:47PM -0500, Christoph Lameter wrote:
> > I already acked a patch like this today.
> 
> It isn't in my inbox.

It was "[PATCH] x86, apic: Fix unmasked CPU initialization" 
<http://www.spinics.net/lists/kernel/msg1820725.html>

Sorry you weren't included; I used get_maintainer.pl for the recipient list.

I also posted it with a smaller recipient list including you on Friday under 
the title
"[PATCH] x86: Restore missing cpumask_copy() in __x2apic_send_IPI_mask" 
<http://www.spinics.net/lists/kernel/msg1819784.html>

Good to see it's solved now anyway. Since I've been using the same patch for 
the last few days,

Tested-by: Ted Percival <ted@tedp.id.au>

