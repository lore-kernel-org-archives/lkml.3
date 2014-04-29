Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349AbaD2AAy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 20:00:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34805 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752721AbaD2AAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 20:00:50 -0400
Date: Mon, 28 Apr 2014 20:00:31 -0400
From: Dave Jones <davej@redhat.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Linux MM <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        davidlohr@hp.com, Rik van Riel <riel@redhat.com>,
        Michel Lespinasse <walken@google.com>, Hugh Dickins <hughd@google.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [BUG] kernel BUG at mm/vmacache.c:85!
Message-ID: <20140429000031.GA4284@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
	Linux MM <linux-mm@kvack.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	davidlohr@hp.com, Rik van Riel <riel@redhat.com>,
	Michel Lespinasse <walken@google.com>,
	Hugh Dickins <hughd@google.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <535EA976.1080402@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <535EA976.1080402@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 12:48:14AM +0530, Srivatsa S. Bhat wrote:
 > Hi,
 > 
 > I hit this during boot on v3.15-rc3, just once so far.
 > Subsequent reboots went fine, and a few quick runs of multi-
 > threaded ebizzy also didn't recreate the problem.
 > 
 > The kernel I was running was v3.15-rc3 + some totally
 > unrelated cpufreq patches.

Could you post those patches somewhere ?
They may not be directly related to the code in the trace, but if
they are randomly corrupting memory, maybe that would explain things ?

	Dave

