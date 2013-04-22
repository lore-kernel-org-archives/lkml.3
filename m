Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583Ab3DVDOd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 23:14:33 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:64245 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754490Ab3DVDOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 23:14:31 -0400
MIME-Version: 1.0
In-Reply-To: <2533805.egcIGXDHJD@vostro.rjw.lan>
References: <CA+icZUU_K9PiFMqMsOEk1+c2DX8LrUojZptPiRVarv4dcB2qFA@mail.gmail.com>
	<516C25AE.4050503@intel.com>
	<CAKohpo=OOPBYCD_K6RLw2YrJxhMokwrOww4QM2t2T4SnGObyQQ@mail.gmail.com>
	<2533805.egcIGXDHJD@vostro.rjw.lan>
Date: Mon, 22 Apr 2013 08:44:30 +0530
Message-ID: <CAKohponuipht4BKoWjuk1HQyovdAO7mOQaRbWWepXQCWvKLyEw@mail.gmail.com>
Subject: Re: linux-next: Tree for Apr 9 [cpufreq: NULL pointer deref]
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>, sedat.dilek@gmail.com,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Nathan Zimmer <nzimmer@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 April 2013 05:00, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Applied to linux-pm.git/linux-next, although please check the result, because
> the patchwork version of the patch wasn't quite applicable and I fixed it up
> manually.

Yes it looks fine and that's why i have attached the patch with my
email earlier.
