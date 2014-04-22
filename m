Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756278AbaDVNmh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 09:42:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39815 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755973AbaDVNm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 09:42:28 -0400
Date: Tue, 22 Apr 2014 15:42:25 +0200
From: Jean Delvare <jdelvare@suse.de>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, Josh Boyer <jwboyer@fedoraproject.org>
Subject: Re: Hardware dependencies in Kconfig
Message-ID: <20140422154225.759880c5@endymion.delvare>
In-Reply-To: <20140415045214.GA32541@kroah.com>
References: <20140414145359.48b7337c@endymion.delvare>
	<20140414191143.GA26864@kroah.com>
	<20140414231254.392c0df8@endymion.delvare>
	<20140415045214.GA32541@kroah.com>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2014 21:52:14 -0700, Greg KH wrote:
> I'd argue that your build systems need to get faster, the laptop I'm
> typing this on can do a full modconfig build, with over 3000 modules, in
> around 20 minutes.  My build server in the cloud can do that in less
> than 5 minutes, and that's not a very fast machine these days.

For the record, and again underlining that this isn't the problem I was
discussing originally: an allmodconfig build on my workstation takes a
over 38 minutes. This is a Xeon 5520 CPU (4 cores + HT) and I'm
building on an SSD. The machine is otherwise idle. While this isn't
exactly brand new hardware, it is still reasonably powerful, and 38
minutes is time, especially when you're waiting for the build to
complete before you can resume working on something.

-- 
Jean Delvare
SUSE L3 Support
