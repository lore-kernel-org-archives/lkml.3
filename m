Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196Ab3D2We6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 18:34:58 -0400
Received: from mga03.intel.com ([143.182.124.21]:4915 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758221Ab3D2We5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 18:34:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,576,1363158000"; 
   d="scan'208";a="234502521"
Date: Mon, 29 Apr 2013 15:34:55 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 2/2] perf, x86: Don't allow unusual PEBS raw flags
Message-ID: <20130429223455.GH19487@tassilo.jf.intel.com>
References: <1366844694-2770-1-git-send-email-andi@firstfloor.org>
 <1366844694-2770-2-git-send-email-andi@firstfloor.org>
 <CABPqkBQSXWTd=ut+U-Mc8fEm+FaV7XAsWydTxQ7e+jSynpKU7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBQSXWTd=ut+U-Mc8fEm+FaV7XAsWydTxQ7e+jSynpKU7w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Could you explain why those listed in the aliases avoid that problem?

The aliases are widely used now (by perf), so as a special case are expected
to work now (at least as long as we enable it by model number)

-Andi
