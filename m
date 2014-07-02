Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928AbaGBPHf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 11:07:35 -0400
Received: from qmta06.emeryville.ca.mail.comcast.net ([76.96.30.56]:45614 "EHLO
	qmta06.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750880AbaGBPHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 11:07:34 -0400
Date: Wed, 2 Jul 2014 10:07:31 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: David Rientjes <rientjes@google.com>, Sasha Levin <sasha.levin@oracle.com>,
        Wei Yang <weiyang@linux.vnet.ibm.com>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Re: mm: slub: invalid memory access in setup_object
In-Reply-To: <20140701144947.5ce3f93729759d8f38d7813a@linux-foundation.org>
Message-ID: <alpine.DEB.2.11.1407021006270.18104@gentwo.org>
References: <53AAFDF7.2010607@oracle.com> <alpine.DEB.2.11.1406251228130.29216@gentwo.org> <alpine.DEB.2.02.1406301500410.13545@chino.kir.corp.google.com> <alpine.DEB.2.11.1407010956470.5353@gentwo.org>
 <20140701144947.5ce3f93729759d8f38d7813a@linux-foundation.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jul 2014, Andrew Morton wrote:

> I can copy that text over and add the reported-by etc (ho hum) but I
> have a tiny feeling that this patch hasn't been rigorously tested?

The testing so far was to verify that  a kernel successfully builds with
the patch and then booted upo in a kvm instance.

