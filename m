Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140AbaDOJD4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 05:03:56 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:36158 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbaDOJDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 05:03:52 -0400
Date: Tue, 15 Apr 2014 11:03:48 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "Chen, Gong" <gong.chen@linux.intel.com>
Cc: hpa@zytor.com, tony.luck@intel.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org
Subject: Re: [PATCH] x86, MCE: Clean get_cpu_xxx with this_cpu_xxx
Message-ID: <20140415090347.GA31409@gmail.com>
References: <1397546035-6384-1-git-send-email-gong.chen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397546035-6384-1-git-send-email-gong.chen@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Chen, Gong <gong.chen@linux.intel.com> wrote:

> This is a cleanup patch suggested by Peter. Use new
> this_cpu_xxx to improve operation speed. Meanwhile,
> it fixes an issue introduced in commit 27f6c573e0. I
> forget to execute put_cpu_var operation after get_cpu_var.

What 'issue'? Is it a bug? If yes, what are the symptoms to the user?

Also, fixes must be separate from cleanups.

Thanks,

	Ingo
