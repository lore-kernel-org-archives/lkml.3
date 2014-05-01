Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080AbaEAUX6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 16:23:58 -0400
Received: from qmta13.emeryville.ca.mail.comcast.net ([76.96.27.243]:51007
	"EHLO qmta13.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751762AbaEAUX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 16:23:57 -0400
Date: Thu, 1 May 2014 15:23:53 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Andrew Morton <akpm@linux-foundation.org>
cc: Sasha Levin <sasha.levin@oracle.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Glauber Costa <glommer@parallels.com>,
        Pekka Enberg <penberg@kernel.org>, akpm@linuxfoundation.org
Subject: Re: fs: dcookie: freeing active timer
In-Reply-To: <20140501131005.2aca98242477d8f98e33b19f@linux-foundation.org>
Message-ID: <alpine.DEB.2.10.1405011522240.19473@gentwo.org>
References: <53594244.6070305@oracle.com> <20140424172708.GY18016@ZenIV.linux.org.uk> <53594B16.4000901@oracle.com> <20140424215558.GZ18016@ZenIV.linux.org.uk> <20140424234941.GA18016@ZenIV.linux.org.uk> <5359D70B.2070604@oracle.com> <53616F92.4020709@oracle.com>
 <alpine.DEB.2.10.1404301819140.27262@gentwo.org> <20140501131005.2aca98242477d8f98e33b19f@linux-foundation.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 May 2014, Andrew Morton wrote:

> OK, I seem to have pieced it all together.  The changelog sucked :( I
> fixed it up a bit but I still don't see why we added that
> SLAB_SUPPORTS_SYSFS thing.  Why do slab and slub differ here?  What
> about slob?

SLAB currently only supports /proc/slabinfo and not
/sys/kernel/slab/*. We talked about adding that and someone was working on
it.


