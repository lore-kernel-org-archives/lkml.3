Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757148Ab3D2O4X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 10:56:23 -0400
Received: from a9-58.smtp-out.amazonses.com ([54.240.9.58]:57849 "EHLO
	a9-58.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752505Ab3D2O4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 10:56:22 -0400
X-Greylist: delayed 372 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Apr 2013 10:56:22 EDT
Date: Mon, 29 Apr 2013 14:50:08 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Han Pingtian <hanpt@linux.vnet.ibm.com>
cc: LKML <linux-kernel@vger.kernel.org>, mhocko@suse.cz, penberg@kernel.org,
        rientjes@google.com, linux-mm@kvack.org
Subject: Re: OOM-killer and strange RSS value in 3.9-rc7
In-Reply-To: <20130427112418.GC4441@localhost.localdomain>
Message-ID: <0000013e5645b356-09aa6796-0a95-40f1-8ec5-6e2e3d0c434f-000000@email.amazonses.com>
References: <20130418101541.GC2672@localhost.localdomain> <20130418175513.GA12581@dhcp22.suse.cz> <20130423131558.GH8001@dhcp22.suse.cz> <20130424044848.GI2672@localhost.localdomain> <20130424094732.GB31960@dhcp22.suse.cz>
 <0000013e3cb0340d-00f360e3-076b-478e-b94c-ddd4476196ce-000000@email.amazonses.com> <20130425060705.GK2672@localhost.localdomain> <0000013e427023d7-9456c313-8654-420c-b85a-cb79cc3c4ffc-000000@email.amazonses.com> <20130426062436.GB4441@localhost.localdomain>
 <0000013e46cba821-d5c54c99-3b5c-4669-9a54-9fb8f4ee516f-000000@email.amazonses.com> <20130427112418.GC4441@localhost.localdomain>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.04.29-54.240.9.58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Apr 2013, Han Pingtian wrote:

> and it is called so many times that the boot cannot be finished. So
> maybe the memory isn't freed even though __free_slab() get called?

Ok that suggests an issue with the page allocator then.
