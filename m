Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933495Ab3ECQ24 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 12:28:56 -0400
Received: from a9-46.smtp-out.amazonses.com ([54.240.9.46]:38536 "EHLO
	a9-46.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932481Ab3ECQ2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 12:28:55 -0400
X-Greylist: delayed 755 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 May 2013 12:28:55 EDT
Date: Fri, 3 May 2013 16:16:18 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Michal Hocko <mhocko@suse.cz>
cc: Han Pingtian <hanpt@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, penberg@kernel.org,
        rientjes@google.com, linux-mm@kvack.org
Subject: Re: OOM-killer and strange RSS value in 3.9-rc7
In-Reply-To: <20130503153450.GA18709@dhcp22.suse.cz>
Message-ID: <0000013e6b2e06ab-a26ffcc5-a52d-4165-9be0-025ae813da00-000000@email.amazonses.com>
References: <0000013e427023d7-9456c313-8654-420c-b85a-cb79cc3c4ffc-000000@email.amazonses.com> <20130426062436.GB4441@localhost.localdomain> <0000013e46cba821-d5c54c99-3b5c-4669-9a54-9fb8f4ee516f-000000@email.amazonses.com> <20130427112418.GC4441@localhost.localdomain>
 <0000013e5645b356-09aa6796-0a95-40f1-8ec5-6e2e3d0c434f-000000@email.amazonses.com> <20130429145711.GC1172@dhcp22.suse.cz> <20130502105637.GD4441@localhost.localdomain> <0000013e65cb32b3-047cd2d6-dfc8-41d2-a792-9b398f9a1baf-000000@email.amazonses.com>
 <20130503030345.GE4441@localhost.localdomain> <0000013e6aff6f95-b8fa366e-51a5-4632-962e-1b990520f5a8-000000@email.amazonses.com> <20130503153450.GA18709@dhcp22.suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.05.03-54.240.9.46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 May 2013, Michal Hocko wrote:

> > Both should be fixed.
>
> Could you point to the specific commit(s), please?
>
> > Making requests for large amounts of memory from an allocator that is
> > supposed to hand out fraction of a page does not make sense.
>
> AFAIR there were lots of objects in size-512 as well.

Looks like I have confused two different issues here. Sorry.

