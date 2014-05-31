Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914AbaEaBIG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 21:08:06 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:10036 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754711AbaEaBIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 21:08:04 -0400
Date: Fri, 30 May 2014 21:07:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Borislav Petkov <bp@alien8.de>, "Chen, Gong" <gong.chen@linux.intel.com>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/7 v6] trace, RAS: Add eMCA trace event interface
Message-ID: <20140530210759.267a854e@gandalf.local.home>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F32823D2B@ORSMSX114.amr.corp.intel.com>
References: <1400142646-10127-1-git-send-email-gong.chen@linux.intel.com>
	<1401247938-22125-1-git-send-email-gong.chen@linux.intel.com>
	<1401247938-22125-2-git-send-email-gong.chen@linux.intel.com>
	<20140528112832.5f83c66b@gandalf.local.home>
	<20140528163452.GF17196@pd.tnic>
	<20140528125625.6f6dcf7f@gandalf.local.home>
	<20140530092232.GA13495@gchen.bj.intel.com>
	<20140530100716.GE28131@pd.tnic>
	<3908561D78D1C84285E8C5FCA982C28F32823D2B@ORSMSX114.amr.corp.intel.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 May 2014 23:03:27 +0000
"Luck, Tony" <tony.luck@intel.com> wrote:

 
> All of this stuff only applies to server systems - so quibbling over
> a handful of *bytes* in an error record on a system that has tens,
> hundreds or even thousands of *gigabytes* of memory seems
> a bit pointless.

But there's still only a limited number of bytes in the ring buffer no
matter what the system, thus we still need to quibble over it.

-- Steve
