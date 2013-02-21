Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101Ab3BURR6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 12:17:58 -0500
Received: from mail-ve0-f177.google.com ([209.85.128.177]:38632 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683Ab3BURR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 12:17:56 -0500
MIME-Version: 1.0
In-Reply-To: <5124D276.4020802@infracom.it>
References: <50BDF345.60804@gmail.com>
	<1354630272.2480.4.camel@rzhang1-mobl4>
	<50BEF830.6020206@gmail.com>
	<50D1CF9D.2090709@infracom.it>
	<CADuOw61+kM6o-zK=7ZTZQSDU8-y-_NcmAaVJFnaSzNBXuqzggg@mail.gmail.com>
	<1361319657.2264.0.camel@rzhang1-mobl4>
	<5124D276.4020802@infracom.it>
Date: Thu, 21 Feb 2013 18:17:54 +0100
Message-ID: <CADuOw60MnsGOb+rd=ANJuJtHmp7nnr+oWV5j3396YHEOrV84Mg@mail.gmail.com>
Subject: Re: regression in linux 3.7 - fan speed at 100% after suspend/resume
 at 100%
From: Salvatore Sisinni <s.sisinni@gmail.com>
To: Roberto Oppedisano <roberto.oppedisano@infracom.it>
Cc: Zhang Rui <rui.zhang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "eduardo.valentin@ti.com" <eduardo.valentin@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 2:41 PM, Roberto Oppedisano
<roberto.oppedisano@infracom.it> wrote:

> Il 20/02/2013 01:20, Zhang Rui ha scritto:

>> can you please check if the problem still exists in the -next branch of
>> git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux.git
>
>
> I had a merge conflict resolved with a:
>
> git rm drivers/thermal/exynos_thermal.c
>
> (the file is unused with my config).
>
> Anyway now I'm running on your next branch and the problem seems to be gone
> (I tried a couple of suspend resume cycles).

Sorry, I cannot confirm
no errors reported during the build but there are minor issues with
the packages produced by "make rpm" that I have not been able to deal
with

rpm -ivh --test kernel-3.8.0_rc2+-1.x86_64.rpm
file /lib/modules from install of kernel-3.8.0_rc2+-1.x86_64 conflicts
with file from package filesystem-3.1-2.fc18.x86_64

rpmbuild --rebuild kernel-3.8.0_rc2+-1.src.rpm

+ cp /home/rpmbuilder/rpmbuild/BUILDROOT/kernel-3.8.0_rc2+-1.x86_64/boot/vmlinuz-3.8.0-rc2+
cp: missing destination file operand after
'/home/rpmbuilder/rpmbuild/BUILDROOT/kernel-3.8.0_rc2+-1.x86_64/boot/vmlinuz-3.8.0-rc2+'
Try 'cp --help' for more information.
error: Bad exit status from /var/tmp/rpm-tmp.HlvpWU (%install)
