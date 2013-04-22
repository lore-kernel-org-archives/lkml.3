Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123Ab3DVLwC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 07:52:02 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:40603 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751896Ab3DVLv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 07:51:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>, sedat.dilek@gmail.com,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Nathan Zimmer <nzimmer@sgi.com>
Subject: Re: linux-next: Tree for Apr 9 [cpufreq: NULL pointer deref]
Date: Mon, 22 Apr 2013 14:00:01 +0200
Message-ID: <1432322.Gxoq9LXUAO@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc8+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAKohponuipht4BKoWjuk1HQyovdAO7mOQaRbWWepXQCWvKLyEw@mail.gmail.com>
References: <CA+icZUU_K9PiFMqMsOEk1+c2DX8LrUojZptPiRVarv4dcB2qFA@mail.gmail.com> <2533805.egcIGXDHJD@vostro.rjw.lan> <CAKohponuipht4BKoWjuk1HQyovdAO7mOQaRbWWepXQCWvKLyEw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 22, 2013 08:44:30 AM Viresh Kumar wrote:
> On 22 April 2013 05:00, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > Applied to linux-pm.git/linux-next, although please check the result, because
> > the patchwork version of the patch wasn't quite applicable and I fixed it up
> > manually.
> 
> Yes it looks fine and that's why i have attached the patch with my
> email earlier.

Yes, I forgot about the attachment and saw it again only after I had applied
the patch.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
