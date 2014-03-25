Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851AbaCYKP5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 06:15:57 -0400
Received: from numidia.opendz.org ([98.142.220.152]:41339 "EHLO
	numidia.opendz.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbaCYKPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 06:15:53 -0400
Date: Tue, 25 Mar 2014 11:15:50 +0100
From: Djalal Harouni <tixxdz@opendz.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] procfs: make /proc/*/{stack,syscall,personality}
 0400
Message-ID: <20140325101550.GA3283@dztty>
References: <CACVxJT8YFTimO-XeQt--zezwvrwEVCRqmN5ocOoGuWuJkzTQVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVxJT8YFTimO-XeQt--zezwvrwEVCRqmN5ocOoGuWuJkzTQVw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexey,

On Mon, Mar 24, 2014 at 04:41:43PM +0300, Alexey Dobriyan wrote:
> > - ONE("stack",      S_IRUGO, proc_pid_stack),
> > + ONE("stack",      S_IRUSR, proc_pid_stack),
> 
> no love for /proc/*/wchan?

Yes you are right, didn't want to modify lot of things, and I missed that one.

So there is the ptrace check that will just block cases where users do
_not_ play tricks with the fd. I'll send another v3 with that included.

Thanks!

-- 
Djalal Harouni
http://opendz.org
