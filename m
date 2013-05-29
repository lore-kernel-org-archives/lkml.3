Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965795Ab3E2LU0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 07:20:26 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:54033 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965683Ab3E2LUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 07:20:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: System slow down from udev
Date: Wed, 29 May 2013 13:29:15 +0200
Message-ID: <7385243.PHJHW0xyGs@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAE9FiQUqHBuoAMeLYDa1GCD8yD+S1QHwxnF4gVPFpgQaatf+Hg@mail.gmail.com>
References: <CAE9FiQUbSeCGTsukX3zfVYBhFKgWfVd8WDDvpix==wSXzc=RVQ@mail.gmail.com> <2013173.c6WKZTQWxj@vostro.rjw.lan> <CAE9FiQUqHBuoAMeLYDa1GCD8yD+S1QHwxnF4gVPFpgQaatf+Hg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 28, 2013 08:46:11 PM Yinghai Lu wrote:
> On Tue, May 28, 2013 at 5:30 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Tuesday, May 28, 2013 05:01:41 PM Yinghai Lu wrote:
> >
> > Please attach your .config for comparison and maybe Greg will have an idea about what's up with udev vs that commit (Greg, the
> > commit in question, unfortunately far from trivial, is http://git.kernel.org/cgit/linux/kernel/git/rafael/linux-pm.git/commit/?h=acpi-hotplug&id=ac212b6980d8d5eda705864fc5a8ecddc6d6eacc).
> 
> config file attached.

On your systems the processor driver is built-in.  Any chance to build it as
a module and see if that helps?

Well, I thought I tested the built-in variant, but I'm going to test it again
later today.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
