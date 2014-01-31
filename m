Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932738AbaAaTfN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 14:35:13 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:58854 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932619AbaAaTfK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 14:35:10 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Kumar Gala <galak@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] arm: qcom: Split Qualcomm support into legacy and multiplatform
Date: Fri, 31 Jan 2014 20:34:46 +0100
Message-ID: <3511712.H3ChLoqCm7@wuerfel>
User-Agent: KMail/4.11 rc1 (Linux/3.10.0-5-generic; KDE/4.11.2; x86_64; ; )
In-Reply-To: <2B2190A4-6689-40D8-A3D7-BD2D882A2CF6@codeaurora.org>
References: <1391107002-21470-1-git-send-email-galak@codeaurora.org> <201401312020.16984.arnd@arndb.de> <2B2190A4-6689-40D8-A3D7-BD2D882A2CF6@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
X-Provags-ID: V02:K0:lhmfco6L7Nzne+FR9MmqC1cVNWla381SJvzMJcQO5um
 7I6EfRAd4IJENxdmvbO1i976gT7vLwDKPZYwe6NrZbSp/QA+7N
 2Ud2EseNtUnRJPF4QfBe9ifrUdOuaizpJRpUsxo84dK9fC+j4m
 1IxHaLIsapncv5J/lhrVDRcTRcO7DMWPnXFIVD0kZ1J27DjxUc
 dPjsRFiNrv7CZ/z+v1ngqs3Queez9Z+H5HXpSBD5XSyj4yHzBW
 THbO+Nk6vdxOytxetRedmyrfbm7b+28JKx1AlnX9i4ExRn5rub
 sx345NfaG3M5ScZOJO7AW5ippXxsNDjEFZBidauSXKE2a4vpQC
 4e32N/Zg862M6Eoo9J00=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 31 January 2014 13:25:25 Kumar Gala wrote:
> > The hotplug.c change sticks out as something that isn't just a move
> > of code to another place, but deletion of unused code. It would
> > be nice to split that out into a separate change, possibly together
> > with the trivial board.c and smp.c changes.
> 
> That’s not 100% true, the hotplug.c code implemented msm_cpu_die, which moved into smp.c
> 
> I can split out scm*/smp* into a patch to enable smp if that is really desired, but not exactly sure what it gets us.
> 

It's not extremely important, I just prefer splitting patches
that have any kind of functional change from trivial moves.

If something happens to break for an unforseen reason, it's
easier to bisect to the patch that does the change.

	Arnd
