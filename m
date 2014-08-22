Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755802AbaHVGCN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 02:02:13 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:49798 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbaHVGCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 02:02:09 -0400
MIME-Version: 1.0
In-Reply-To: <CAFTL4hxJ2roTB3tZBmXU3HRetgFSUT0LNVWfX-Y2hbpyXSo2pg@mail.gmail.com>
References: <20140811200931.GA18865@redhat.com> <1408566691-3023-1-git-send-email-iacobcatalin@gmail.com>
 <CAFTL4hxJ2roTB3tZBmXU3HRetgFSUT0LNVWfX-Y2hbpyXSo2pg@mail.gmail.com>
From: Catalin Iacob <iacobcatalin@gmail.com>
Date: Fri, 22 Aug 2014 08:01:48 +0200
Message-ID: <CAHg_5gq1XiZ1A08PtQ7Rof3rUXJ-pVYkXtmHqgFh6hB+++qPNg@mail.gmail.com>
Subject: Re: nohz fail (was: perf related boot hang.)
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Dave Jones <davej@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2014 at 4:56 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> Can you please test the series I just posted: "[RFC PATCH 0/9] nohz:
> Nohz full kick fixes"?

Before applying the series I tried one more Firefox build which
triggered the panic after less than 5 minutes.

After applying the series I did 2 full builds (around 60 minutes in
total) with no problem.
