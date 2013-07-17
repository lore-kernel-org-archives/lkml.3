Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625Ab3GQHg0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 03:36:26 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:59597 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516Ab3GQHgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 03:36:24 -0400
X-AuditID: cbfee61b-b7efe6d000007b11-08-51e64976bc37
Date: Wed, 17 Jul 2013 09:36:14 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>, l.majewski@majess.pl,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH v5 7/7] Documentation:cpufreq:boost: Update BOOST
 documentation
Message-id: <20130717093614.1ee4839e@amdc308.digital.local>
In-reply-to: <CAKohponeZ15ruJA9__V70u1Ztr4F9aT+zBinMT5Ewyew53rbyQ@mail.gmail.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1372927830-2949-1-git-send-email-l.majewski@samsung.com>
 <1372927830-2949-8-git-send-email-l.majewski@samsung.com>
 <CAKohpo=oB_4gGtNn6jvxSCp665pOq6oqeTCCyGzmN_eWqt0Lhg@mail.gmail.com>
 <20130716133319.49ed0838@amdc308.digital.local>
 <CAKohponeZ15ruJA9__V70u1Ztr4F9aT+zBinMT5Ewyew53rbyQ@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjkeLIzCtJLcpLzFFi42I5/e+xgG6Z57NAg9cPjSz+vF3OavG06Qe7
	xbzPshZr9v9ksug8+4TZonfBVTaLN4+4LS7vmsNm8bn3CKPF7cYVbBb9C3uZLJ487GOz2PjV
	w4HXY/Gel0wed67tYfNYN+0ts0ffllWMHo8WtzB6HL+xncnj8ya5APYoLpuU1JzMstQifbsE
	roxTTxqZCpr5Kk6sfs7SwPiOq4uRk0NCwERi7qPb7BC2mMSFe+vZuhi5OIQEFjFKvH7bwwLh
	tDNJrFo5iQWkikVAVWLKjhZWEJtNQE/i892nTF2MHBwiAloSL2+mgtQzC3xklrh78DZYvbBA
	qERbxw02EJtXwFpi8vy/YL2cAsESLTd2Q237yyRx+PJPsCJ+AUmJ9n8/mCFOspM492kDO0Sz
	oMSPyffAhjIDLdu8rYkVwpaX2LzmLfMERsFZSMpmISmbhaRsASPzKkbR1ILkguKk9FwjveLE
	3OLSvHS95PzcTYzgWHomvYNxVYPFIUYBDkYlHt4JYU8DhVgTy4orcw8xSnAwK4nwVms8CxTi
	TUmsrEotyo8vKs1JLT7EKM3BoiTOe7DVOlBIID2xJDU7NbUgtQgmy8TBKdXAqF55xO6Z9uen
	jlIuZw8vP9KuMfHdQ6tHpZcOe39dI6597ujl91nvil/MmjD1gOZ10cfLts973jp99rI5Dz94
	NTMmh/hXeboJlbmUr/menlZp4vr2/Yw874niZ/cpM/1NPLK8ss5qVYiIwbafd5eKfi46tKGW
	cdrRWXcm79r6/98njrP3hHPf5R5VYinOSDTUYi4qTgQAOc1FSaECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jul 2013 10:52:18 +0530 Viresh Kumar viresh.kumar@linaro.org
wrote,
> On 16 July 2013 17:03, Lukasz Majewski <l.majewski@samsung.com> wrote:
> > As fair as I've understood our previous discussion (at [*]) we have
> > agreed about this. We only export boost attribute when it is
> > supported by cpufreq_driver. Rafael was very clear about exporting
> > boost attribute:
> >
> > "Simple: Export it only when supported."
> >
> > [*]: Re: [PATCH v4 2/7] cpufreq: Add boost frequency support in core
> 
> I don't want to search in the Archives but I am sure what we decided
> earlier.

At v4 there was the old acpi-cpufreq.c behaviour preserved (with always
exporting boost - when not supported ro, when supported rw).

Due to Rafael and Dirk comments it has been rewritten at v5:

http://thread.gmane.org/gmane.linux.kernel/1511831/match=patch+v4+2+7+cpufreq+add+boost+frequency+support+core


> 
> Rafael Said:
> "Simple: Export it only when supported."
              [*]

> 
> AND
> 
> "Don't change behavior of acpi-cpufreq driver" 
              [**]
> 
> If you see acpi-cpufreq driver carefully, it always creates "boost"
> sysfs entry. If its not supported then it creates a read only entry.

For me those two statements [*] and [**] contradict:

At v5:
1. ARM - export "boost" only when supported (rw)
2. x86 - export boost only when x86 supports it (as rw). When x86
	 doesn't support HW boost - DO NOT export it at all.

At v4:
1. ARM - export "boost" only when supported (rw)
2. x86 - always export boost - no matter if supported or not. If not
	 supported, then export it as ro only.


> 
> So, please preserve that.


-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
