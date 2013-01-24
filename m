Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980Ab3AXL4t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 06:56:49 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:58062 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868Ab3AXL4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 06:56:42 -0500
Date: Thu, 24 Jan 2013 12:56:37 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, acme@redhat.com, jolsa@redhat.com,
        namhyung.kim@lge.com
Subject: Re: [PATCH v6 00/18] perf: add memory access sampling support
Message-ID: <20130124115637.GA523@gmail.com>
References: <1358264386-24633-1-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358264386-24633-1-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephane Eranian <eranian@google.com> wrote:

> This patch series had a new feature to the kernel perf_events 
> interface and corresponding user level tool, perf.

Would be nice to merge this with the overlapping parts of Andi's 
Haswell series.

Thanks,

	Ingo
