Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826AbaGBOUZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 10:20:25 -0400
Received: from qmta13.emeryville.ca.mail.comcast.net ([76.96.27.243]:37258
	"EHLO qmta13.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752876AbaGBOUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 10:20:24 -0400
Date: Wed, 2 Jul 2014 09:20:20 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Wei Yang <weiyang@linux.vnet.ibm.com>
cc: David Rientjes <rientjes@google.com>, Sasha Levin <sasha.levin@oracle.com>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Re: mm: slub: invalid memory access in setup_object
In-Reply-To: <20140702020454.GA6961@richard>
Message-ID: <alpine.DEB.2.11.1407020918130.17773@gentwo.org>
References: <53AAFDF7.2010607@oracle.com> <alpine.DEB.2.11.1406251228130.29216@gentwo.org> <alpine.DEB.2.02.1406301500410.13545@chino.kir.corp.google.com> <alpine.DEB.2.11.1407010956470.5353@gentwo.org> <20140702020454.GA6961@richard>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jul 2014, Wei Yang wrote:

> My patch is somewhat convoluted since I wanted to preserve the original logic
> and make minimal change. And yes, it looks not that nice to audience.

Well I was the author of the initial "convoluted" logic.

> I feel a little hurt by this patch. What I found and worked is gone with this
> patch.

Ok how about giving this one additional revision. Maybe you can make the
function even easier to read? F.e. the setting of the NULL pointer at the
end of the loop is ugly.
