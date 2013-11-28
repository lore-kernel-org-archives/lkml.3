Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758081Ab3K1KhA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 05:37:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38290 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151Ab3K1Kg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 05:36:59 -0500
Date: Thu, 28 Nov 2013 11:36:27 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCHv2 0/7] perf tools: Add data file write interface
Message-ID: <20131128103627.GB1245@krava.brq.redhat.com>
References: <1385634619-8129-1-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385634619-8129-1-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 28, 2013 at 11:30:12AM +0100, Jiri Olsa wrote:
> hi,
> adding perf_data_file__write function to centralize
> output file writes. Using it in record and inject
> commands.
> 
> v2 changes:
>   - changes for readn function, suggested by Ingo
>   - added writen function, suggested by Arnaldo
>   - spliting record change into 2 separated patches
>   - omiting some unnecessary changes in the inject change

available in here:
  git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
  perf/data5

jirka
