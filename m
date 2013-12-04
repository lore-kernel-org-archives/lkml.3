Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933141Ab3LDTBx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 14:01:53 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62282 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753590Ab3LDTBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 14:01:49 -0500
Date: Wed, 4 Dec 2013 20:01:45 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, "Yan, Zheng" <zheng.z.yan@intel.com>,
        Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
Subject: Re: [PATCH] perf/x86: fix bug in event constraint end marker macro
Message-ID: <20131204190145.GA9093@gmail.com>
References: <20131204090028.GA9724@quad>
 <20131204090336.GA31973@gmail.com>
 <CABPqkBR4PWFB2z9xhMa9qiJxBXxV5kq8k93PdxWfdj-3EmGb9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBR4PWFB2z9xhMa9qiJxBXxV5kq8k93PdxWfdj-3EmGb9Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephane Eranian <eranian@google.com> wrote:

> Ingo,
> 
> Ok, I have asked Maria to clean the patch up add more comments and
> repost a new version of the
> patch. She will repost ASAP.

Ok!

Thanks,

	Ingo
