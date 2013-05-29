Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935188Ab3E2VZ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 17:25:56 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:54342 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932609Ab3E2VZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 17:25:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: System slow down from udev
Date: Wed, 29 May 2013 23:34:39 +0200
Message-ID: <2968280.mrRQeH7SYv@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAE9FiQX99+V-jS_h9Lr=mz_n8e1KazUOxcLrAyPG19KJM_3ABg@mail.gmail.com>
References: <CAE9FiQUbSeCGTsukX3zfVYBhFKgWfVd8WDDvpix==wSXzc=RVQ@mail.gmail.com> <7385243.PHJHW0xyGs@vostro.rjw.lan> <CAE9FiQX99+V-jS_h9Lr=mz_n8e1KazUOxcLrAyPG19KJM_3ABg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 29, 2013 01:13:46 PM Yinghai Lu wrote:
> On Wed, May 29, 2013 at 4:29 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On your systems the processor driver is built-in.  Any chance to build it as
> > a module and see if that helps?
> 
> it CONFIG_ACPI_PROCESSOR it not set in the config
> the boot get to normal speed.

Well, if it is not set at all, there won't be problems with it. :-)

I've tested my linux-next branch on OpenSUSE 11.3 both with the processor
driver built in and modular and I'm not able to reproduce the issue you're
seeing.

Moreover, I'm not sure if user space is involved here at all, because the
problem triggers for you when all of the relevant kernel code is non-modular.

With the processor driver enabled, when the slowdown happens, are the systems
usable enough to get some debug info out of them?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
