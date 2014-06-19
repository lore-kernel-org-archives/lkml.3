Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934555AbaFSUj4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 16:39:56 -0400
Received: from qmta12.emeryville.ca.mail.comcast.net ([76.96.27.227]:36571
	"EHLO qmta12.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932343AbaFSUjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 16:39:55 -0400
Date: Thu, 19 Jun 2014 15:39:52 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH RFC] percpu: add data dependency barrier in percpu
 accessors and operations
In-Reply-To: <20140617195634.GQ4669@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.11.1406191539110.4002@gentwo.org>
References: <20140617144151.GD4669@linux.vnet.ibm.com> <20140617152752.GC31819@htj.dyndns.org> <alpine.DEB.2.11.1406171053230.20610@gentwo.org> <20140617160040.GE31819@htj.dyndns.org> <20140617160508.GF31819@htj.dyndns.org> <alpine.DEB.2.11.1406171125340.20610@gentwo.org>
 <CA+55aFxHr8JXwDR-4g4z1mkXvZRtY=OosYcUMPZRD2upfooS1w@mail.gmail.com> <alpine.DEB.2.11.1406171345240.21931@gentwo.org> <20140617185510.GM4669@linux.vnet.ibm.com> <alpine.DEB.2.11.1406171437570.22064@gentwo.org> <20140617195634.GQ4669@linux.vnet.ibm.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jun 2014, Paul E. McKenney wrote:

> During operation that does not involve cross-CPU accesses, agreed.

Well that is the typical operation mode for per cpu data and that is what
it was made designed for.


