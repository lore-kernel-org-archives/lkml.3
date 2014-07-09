Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289AbaGIPsp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 11:48:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:5081 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752523AbaGIPso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 11:48:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,631,1400050800"; 
   d="scan'208";a="570661585"
Date: Wed, 9 Jul 2014 08:46:34 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        jolsa@redhat.com, acme@redhat.com, namhyung@kernel.org
Subject: Re: [PATCH 1/4] perf: add ability to sample machine state on
 interrupt
Message-ID: <20140709154634.GZ19781@tassilo.jf.intel.com>
References: <1404857759-25105-1-git-send-email-eranian@google.com>
 <1404857759-25105-2-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404857759-25105-2-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 12:15:56AM +0200, Stephane Eranian wrote:
> Enable capture of interrupted machine state in each
> sample.

Looks good to me.

Reviewed-by: Andi Kleen <ak@linux.intel.com>

-Andi
