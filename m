Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757062AbaGBTEz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 15:04:55 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:15036 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033AbaGBTEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 15:04:54 -0400
Message-ID: <1404327890.13372.4.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 0/7] [RESEND][v4] x86: rework tlb range flushing code
From: Davidlohr Bueso <davidlohr@hp.com>
To: Dave Hansen <dave@sr71.net>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, x86@kernel.org
Date: Wed, 02 Jul 2014 12:04:50 -0700
In-Reply-To: <20140701164845.8D1A5702@viggo.jf.intel.com>
References: <20140701164845.8D1A5702@viggo.jf.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-01 at 09:48 -0700, Dave Hansen wrote:
> x86 Maintainers,
> 
> Could this get picked up in to the x86 tree, please?  That way,
> it will get plenty of time to bake before the 3.17 merge window.

I had originally tried out this series (~v1, v2 iirc) on large KVM
configurations. Setting the TLB flush tunable to 33 seemed prudent and
didn't cause anything weird. Feel free to add my:

Tested-by: Davidlohr Bueso <davidlohr@hp.com>

