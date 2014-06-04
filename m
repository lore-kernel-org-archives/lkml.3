Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946AbaFDRBK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 13:01:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:33850 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777AbaFDRBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 13:01:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,974,1392192000"; 
   d="scan'208";a="551576014"
Date: Wed, 4 Jun 2014 09:59:30 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, jolsa@redhat.com,
        linux-kernel@vger.kernel.org, acme@infradead.org, fweisbec@gmail.com
Subject: Re: [PATCH 9/9] perf, tools, record: Always allow to overide default
 period v2
Message-ID: <20140604165930.GH8876@tassilo.jf.intel.com>
References: <1401486615-21374-1-git-send-email-andi@firstfloor.org>
 <1401486615-21374-10-git-send-email-andi@firstfloor.org>
 <1401895987.1673.36.camel@leonhard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401895987.1673.36.camel@leonhard>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I saw samples.

Oh well we can just drop it. The only difference is that the 
event list cannot set a period then.

It's as broken as before.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
