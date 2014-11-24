Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932AbaKXWhy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 17:37:54 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:43482 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbaKXWhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 17:37:52 -0500
Date: Mon, 24 Nov 2014 14:37:36 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: jolsa@redhat.com, linux-kernel@vger.kernel.org, namhyung@kernel.org,
        acme@kernel.org, mingo@kernel.org, peterz@infradead.organton,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <michaele@au1.ibm.com>
Subject: Re: perf: Add support for full Intel event lists v8
Message-ID: <20141124223736.GA13184@us.ibm.com>
References: <1406762570-16694-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406762570-16694-1-git-send-email-andi@firstfloor.org>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112422-0005-0000-0000-00000699281C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen [andi@firstfloor.org] wrote:

| Since it seems the download mechanism is controversal, 
| I removed the downloader for now until a suitable distribution
| method with kernel.org can be established. This is just
| the rest of the perf JSON event code that should hopefully
| not be controversal.

Ingo, Jiri, Andi,

Can we get this patchset merged please ? It is a step forward
in eliminating raw event codes right ?

We added hundreds of events to sysfs for Power7. We don't
want to do the same for Power8 because this JSON file solution
is clearly better.

But we currently have a regression in functionality from Power7
to Power8 :-(

Even if 'perf download' is left out this patchset is still
useful IMHO. Users (specially those who currently struggle
with raw codes, are highly qualified and) could wget the
JSON files as and when needed. 

Being able to install the JSON files and download updates is
a big plus, but is something thse users can live without for
now.

Sukadev

