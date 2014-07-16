Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030562AbaGPHVL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 03:21:11 -0400
Received: from mga02.intel.com ([134.134.136.20]:1976 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964954AbaGPHVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 03:21:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,670,1400050800"; 
   d="scan'208";a="573895390"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH V2 0/2] perf tools: Allow deletion of a thread with no map groups
Date: Wed, 16 Jul 2014 10:19:42 +0300
Message-Id: <1405495184-20441-1-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20140714204310.GC18133@kernel.org>
References: <20140714204310.GC18133@kernel.org>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Here is the patch split in two.

Regards
Adrian
