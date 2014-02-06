Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874AbaBFPfO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 10:35:14 -0500
Received: from qmta07.emeryville.ca.mail.comcast.net ([76.96.30.64]:57236 "EHLO
	qmta07.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750775AbaBFPfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 10:35:12 -0500
Date: Thu, 6 Feb 2014 09:35:07 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
cc: paulus@samba.org, oleg@redhat.com, rusty@rustcorp.com.au,
        peterz@infradead.org, tglx@linutronix.de,
        Andrew Morton <akpm@linux-foundation.org>, mingo@kernel.org,
        paulmck@linux.vnet.ibm.com, tj@kernel.org, walken@google.com,
        ego@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Toshi Kani <toshi.kani@hp.com>, Dave Hansen <dave@sr71.net>,
        linux-mm@kvack.org
Subject: Re: [PATCH 48/51] mm, vmstat: Fix CPU hotplug callback
 registration
In-Reply-To: <20140205221322.19080.63386.stgit@srivatsabhat.in.ibm.com>
Message-ID: <alpine.DEB.2.10.1402060934460.31869@nuc>
References: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com> <20140205221322.19080.63386.stgit@srivatsabhat.in.ibm.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Feb 2014, Srivatsa S. Bhat wrote:

> Fix the vmstat code in the MM subsystem by using this latter form of callback
> registration.

Acked-by: Christoph Lameter <cl@linux.com>
