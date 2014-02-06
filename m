Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751420AbaBFXdg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 18:33:36 -0500
Received: from relay1.mentorg.com ([192.94.38.131]:49414 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbaBFXde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 18:33:34 -0500
Date: Thu, 6 Feb 2014 23:33:23 +0000
From: "Joseph S. Myers" <joseph@codesourcery.com>
X-X-Sender: jsm28@digraph.polyomino.org.uk
To: Torvald Riegel <triegel@redhat.com>
CC: Will Deacon <will.deacon@arm.com>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
In-Reply-To: <1391729117.23421.4066.camel@triegel.csb>
Message-ID: <Pine.LNX.4.64.1402062330520.17635@digraph.polyomino.org.uk>
References: <20140206134825.305510953@infradead.org>  <21984.1391711149@warthog.procyon.org.uk>
 <52F3DA85.1060209@arm.com>  <20140206185910.GE27276@mudshark.cambridge.arm.com>
  <1391720965.23421.3884.camel@triegel.csb>  <Pine.LNX.4.64.1402062147020.17635@digraph.polyomino.org.uk>
 <1391729117.23421.4066.camel@triegel.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-OriginalArrivalTime: 06 Feb 2014 23:33:27.0282 (UTC) FILETIME=[D5E60520:01CF2393]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Feb 2014, Torvald Riegel wrote:

> I think that if we have different options, there needs to be agreement
> on which to choose across the compilers, at the very least.  I don't
> quite know how this looks like for GCC and LLVM, for example.

I'm not sure we even necessarily get compatibility for the alignment of 
_Atomic types yet (and no ABI document I've seen discusses that issue).

-- 
Joseph S. Myers
joseph@codesourcery.com
