Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542AbaJ1NGX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 09:06:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:16773 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623AbaJ1NGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 09:06:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,802,1406617200"; 
   d="scan'208";a="612742756"
Date: Tue, 28 Oct 2014 06:04:48 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@kernel.org, tglx@linutronix.de, eranian@google.com,
        dzickus@redhat.com, andi@firstfloor.org, jmario@redhat.com,
        acme@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] perf,x86: De-obfuscate HSW offcore bits
Message-ID: <20141028130448.GH3274@tassilo.jf.intel.com>
References: <20141028123043.257488788@infradead.org>
 <20141028123352.516276191@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141028123352.516276191@infradead.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 01:30:44PM +0100, Peter Zijlstra wrote:
> Andi introduced the HSW cache events array, but used magic constants
> against convention as set by all the other uarchs. Try and deobfuscate
> these a bit.
> 
> The SDM doesn't appear to come close to actually describing the
> offcore but Andi said actual bit definitions were available from:
>   https://download.01.org/perfmon/HSW/Haswell_matrix_bit_definitions_V14.json
> 
> The below script was used to generate the macros.

I already have a script to generate. It can be extended to 
generate the macros.

However again please test the events and only submit them if they 
work. The tested bits I used are all documents in the previous
comments. Anything that differs now needs to be retested by you.

-Andi

