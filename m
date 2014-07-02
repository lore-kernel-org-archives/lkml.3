Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499AbaGBOpD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 10:45:03 -0400
Received: from qmta09.emeryville.ca.mail.comcast.net ([76.96.30.96]:42330 "EHLO
	qmta09.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751538AbaGBOpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 10:45:01 -0400
Date: Wed, 2 Jul 2014 09:44:57 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Sasha Levin <sasha.levin@oracle.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Wei Yang <weiyang@linux.vnet.ibm.com>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Re: mm: slub: invalid memory access in setup_object
In-Reply-To: <53B32D80.8000601@oracle.com>
Message-ID: <alpine.DEB.2.11.1407020935450.17773@gentwo.org>
References: <53AAFDF7.2010607@oracle.com> <alpine.DEB.2.11.1406251228130.29216@gentwo.org> <alpine.DEB.2.02.1406301500410.13545@chino.kir.corp.google.com> <alpine.DEB.2.11.1407010956470.5353@gentwo.org> <20140701144947.5ce3f93729759d8f38d7813a@linux-foundation.org>
 <53B32D80.8000601@oracle.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jul 2014, Sasha Levin wrote:

> Is there a better way to stress test slub?

The typical way to test is by stressing the network subsystem
with small packets that require small allocations. Or do a filesystem
test that requires lots of metadata (file creations, removal, renames
etc).

But I also posted some in kernel benchmarks a while back

https://lkml.org/lkml/2009/10/13/459

Pekka had a project going to get these merged.

https://lkml.org/lkml/2009/11/29/17


