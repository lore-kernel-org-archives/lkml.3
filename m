Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759144Ab3D2XFL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 19:05:11 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:58681 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758327Ab3D2XFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 19:05:10 -0400
MIME-Version: 1.0
In-Reply-To: <20130429223455.GH19487@tassilo.jf.intel.com>
References: <1366844694-2770-1-git-send-email-andi@firstfloor.org>
	<1366844694-2770-2-git-send-email-andi@firstfloor.org>
	<CABPqkBQSXWTd=ut+U-Mc8fEm+FaV7XAsWydTxQ7e+jSynpKU7w@mail.gmail.com>
	<20130429223455.GH19487@tassilo.jf.intel.com>
Date: Tue, 30 Apr 2013 01:05:09 +0200
Message-ID: <CABPqkBQy04g22jdSr=+zJzeBpnneacauq4i=p7GdJp+w_C9Jzg@mail.gmail.com>
Subject: Re: [PATCH 2/2] perf, x86: Don't allow unusual PEBS raw flags
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 30, 2013 at 12:34 AM, Andi Kleen <ak@linux.intel.com> wrote:
>> Could you explain why those listed in the aliases avoid that problem?
>
> The aliases are widely used now (by perf), so as a special case are expected
> to work now (at least as long as we enable it by model number)
>
I don't get that.

uops_retired:cmask=16:i with precise=2 does not measure
that based on your comments. It measures uops_retired
if the filters are ignored with PEBS.
