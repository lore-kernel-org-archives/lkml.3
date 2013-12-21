Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab3LUDFQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 22:05:16 -0500
Received: from merlin.infradead.org ([205.233.59.134]:45593 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135Ab3LUDFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 22:05:15 -0500
Message-ID: <52B50569.8060909@infradead.org>
Date: Fri, 20 Dec 2013 19:05:13 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Alexis Berlemont <alexis.berlemont@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: perf and Kconfig
References: <CAMesUR48C3zBo_UJByjC9GSqK6V=W_-WDQrsAoGye2yNADD3NQ@mail.gmail.com>
In-Reply-To: <CAMesUR48C3zBo_UJByjC9GSqK6V=W_-WDQrsAoGye2yNADD3NQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/13 16:39, Alexis Berlemont wrote:
> Hi,
> 
> Here is a proposal of a small contribution which tries to fulfill the
> task "Use Kconfig to allow selecting features and build minimal
> version of perf,..." displayed on the todo page of the perf
> wiki (https://perf.wiki.kernel.org/index.php/Todo).
> 
> I tried to continue the work started by David Ahern
> (https://github.com/dsahern/linux.git branch:perf-config). This
> version relies on the features detection tests available in
> linux/tools/perf/config/feature-checks so as to enable some
> configuration options (at least by default).
> 
> This little task is not complete; more Kconfig options should be added
> for each perf tool (top, record, report, ...).
> 
> I just wanted to ask whether you consider this proposal as interesting
> enough for inclusion and if you are ok with the way it is implemented.
> 
> The code is available here: https://github.com/aberlemont/linux.git
> - branch: perf-config.

Hi,

The correct way to have any code reviewed is to post the code (not a link
to it) on the mailing list.

thanks,
-- 
~Randy
