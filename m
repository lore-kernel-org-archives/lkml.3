Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477AbaDGRNJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 13:13:09 -0400
Received: from qmta06.emeryville.ca.mail.comcast.net ([76.96.30.56]:40922 "EHLO
	qmta06.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755167AbaDGRNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 13:13:06 -0400
Date: Mon, 7 Apr 2014 12:13:03 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: Sasha Levin <sasha.levin@oracle.com>
cc: Michal Hocko <mhocko@suse.cz>, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: mm: slub: gpf in deactivate_slab
In-Reply-To: <53401F56.5090507@oracle.com>
Message-ID: <alpine.DEB.2.10.1404071212200.9896@nuc>
References: <53208A87.2040907@oracle.com> <5331A6C3.2000303@oracle.com> <20140325165247.GA7519@dhcp22.suse.cz> <alpine.DEB.2.10.1403251205140.24534@nuc> <5331B9C8.7080106@oracle.com> <alpine.DEB.2.10.1403251308590.26471@nuc> <53321CB6.5050706@oracle.com>
 <alpine.DEB.2.10.1403261042360.2057@nuc> <53401F56.5090507@oracle.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Apr 2014, Sasha Levin wrote:

> Unfortunately I've been unable to reproduce the issue to get more debug info
> out of it. However, I've hit something that seems to be somewhat similar
> to that:

Could you jsut run with "slub_debug" on the kernel command line to get us
more diagnostics? Could be memory corruption.

