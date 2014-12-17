Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280AbaLQOH4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 09:07:56 -0500
Received: from mga01.intel.com ([192.55.52.88]:18654 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968AbaLQOHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 09:07:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,594,1413270000"; 
   d="scan'208";a="649141510"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, adrian.hunter@intel.com,
        markus.t.metzger@intel.com, mathieu.poirier@linaro.org,
        acme@infradead.org
Subject: Re: [PATCH v8 00/14] perf: Add infrastructure and support for Intel PT
In-Reply-To: <1415972627-37514-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1415972627-37514-1-git-send-email-alexander.shishkin@linux.intel.com>
User-Agent: Notmuch/0.17+49~gaa57e9d (http://notmuchmail.org) Emacs/24.4.1 (x86_64-pc-linux-gnu)
Date: Wed, 17 Dec 2014 16:06:12 +0200
Message-ID: <8761daqskr.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Shishkin <alexander.shishkin@linux.intel.com> writes:

> Hi Peter and all,

Hi again,

> Since there weren't too many review comments on the two previous
> versions, here's another one with a couple more fixes.

This patchset is one month old now, I thought somebody might want to
take a look before a send a rebased new version.

Cheers,
--
Alex
