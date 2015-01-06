Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570AbbAFVQN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 16:16:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42690 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218AbbAFVQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 16:16:09 -0500
Date: Tue, 6 Jan 2015 13:16:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Kiran Raparthy <kiran.kumar@linaro.org>, linux-kernel@vger.kernel.org,
        Colin Cross <ccross@android.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [RFC v4] debug: prevent entering debug mode on panic/exception.
Message-Id: <20150106131608.a756b9e8aaf8c496099a5736@linux-foundation.org>
In-Reply-To: <54ABFFD3.2020305@linaro.org>
References: <1419338309-16729-1-git-send-email-kiran.kumar@linaro.org>
	<20150105161412.44f53313e1d771dc9f968264@linux-foundation.org>
	<54ABFFD3.2020305@linaro.org>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Jan 2015 15:31:31 +0000 Daniel Thompson <daniel.thompson@linaro.org> wrote:

> On 06/01/15 00:14, Andrew Morton wrote:
> > We appear to have forgotten to document panic_timeout.  Sigh.
> 
> I knew I'd seen it somewhere...
> 
> Once its been sysctlised it ends up called "panic":
>   https://www.kernel.org/doc/Documentation/sysctl/kernel.txt

Confused.  That file doesn't mention panic_timeout.  But it is the
place where panic_timeout can be described.

