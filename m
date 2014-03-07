Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471AbaCGAP5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 19:15:57 -0500
Received: from g2t2354.austin.hp.com ([15.217.128.53]:50784 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302AbaCGAP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 19:15:56 -0500
Message-ID: <1394151350.2555.2.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 0/7] x86: rework tlb range flushing code
From: Davidlohr Bueso <davidlohr@hp.com>
To: Dave Hansen <dave@sr71.net>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        ak@linux.intel.com, kirill.shutemov@linux.intel.com, mgorman@suse.de,
        alex.shi@linaro.org, x86@kernel.org, linux-mm@kvack.org
Date: Thu, 06 Mar 2014 16:15:50 -0800
In-Reply-To: <20140306004519.BBD70A1A@viggo.jf.intel.com>
References: <20140306004519.BBD70A1A@viggo.jf.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-03-05 at 16:45 -0800, Dave Hansen wrote:
> Reposting with an instrumentation patch, and a few minor tweaks.
> I'd love some more eyeballs on this, but I think it's ready for
> -mm.
> 
> I'm having it run through the LKP harness to see if any perfmance
> regressions (or gains) show up.

fwiw I pounded these on a 80 core Westmere with my usual aim7 stuff for
most of the morning and didn't run into anything unusual or performance
differences.

