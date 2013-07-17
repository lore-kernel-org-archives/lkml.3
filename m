Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166Ab3GQJMH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 05:12:07 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:8919 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab3GQJMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 05:12:01 -0400
X-AuditID: cbfee61b-b7efe6d000007b11-48-51e65fe013f0
Date: Wed, 17 Jul 2013 11:11:41 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        "l.majewski@majess.pl" <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH v5 6/7] cpufreq:boost:Kconfig: Enable software managed
 BOOST support at Kconfig
Message-id: <20130717111141.7b86a304@amdc308.digital.local>
In-reply-to: <CAKohponWhYFntyay004qErHxFRkjZEtes-+ZHE49oG-CrZMzOg@mail.gmail.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1372927830-2949-1-git-send-email-l.majewski@samsung.com>
 <1372927830-2949-7-git-send-email-l.majewski@samsung.com>
 <CAKohpokR=jrcLQQ7VAD+vr7GWgSFBfuqbOhWHwA3FCgk__EJ3Q@mail.gmail.com>
 <20130716135022.64a102f8@amdc308.digital.local>
 <CAKohpo=XbUtYBVQ_y4_R18wpag_HAVvXrxfSfmaNSqq=wLpciQ@mail.gmail.com>
 <20130717091706.69b77c2f@amdc308.digital.local>
 <CAKohpona8E-JgLxyLnc_QuS9LAuJ7FBbsSGPZawQtOd8kRd4JA@mail.gmail.com>
 <20130717101251.164fbad8@amdc308.digital.local>
 <CAKohponWhYFntyay004qErHxFRkjZEtes-+ZHE49oG-CrZMzOg@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphkeLIzCtJLcpLzFFi42I5/e+xoO6D+GeBBk2rhC3+vF3OavG06Qe7
	xbzPshZr9v9ksug8+4TZonfBVTaLN4+4LS7vmsNm8bn3CKPF7cYVbBb9C3uZLJ487GOz2PjV
	w4HXY/Gel0wed67tYfNYN+0ts0ffllWMHo8WtzB6HL+xncnj8ya5APYoLpuU1JzMstQifbsE
	rowbnTNZClYwV/T+e83SwHiKqYuRg0NCwERi0R/DLkZOIFNM4sK99WxdjFwcQgLTGSXmvtvE
	AuG0M0m82vWNEaSKRUBV4tely+wgNpuAnsTnu0/BBokIaEm8vJkKUs8s0MMicejKdjaQGmGB
	VIkP17+xgti8AtYSX3/3sILUcwoES1x+XQIx/z2LxLvlvWA1/AKSEu3/fjBDXGQnce7TBnaI
	XkGJH5PvsYDYzEC7Nm9rYoWw5SU2r3nLPIFRcBaSsllIymYhKVvAyLyKUTS1ILmgOCk910iv
	ODG3uDQvXS85P3cTIziOnknvYFzVYHGIUYCDUYmHd0LY00Ah1sSy4srcQ4wSHMxKIrzVGs8C
	hXhTEiurUovy44tKc1KLDzFKc7AoifMebLUOFBJITyxJzU5NLUgtgskycXBKNTBOtug132Vl
	63P0uOQqJyFfAY579b2m76dfD/69KuzWwdnnaw8z7feW2cms8oprc7tkfdP+F4mep2+lBf3Q
	0mo572N16VvM4V8f3fa+vPGye5a8UpWl2N4TFrkzH/6MEX21U3tNdPBLh+Wtqy/MuL51a8Rt
	i/6l51RdOJbtk5wplHfF43TKxew3SizFGYmGWsxFxYkA7649RJ8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jul 2013 10:29:15 +0200 Viresh Kumar viresh.kumar@linaro.org
wrote,
> On 17 July 2013 13:42, Lukasz Majewski <l.majewski@samsung.com> wrote:
> > Then it should be enough to only write:
> >
> > depends on THERMAL
> >
> > (since CPUFREQ is already enabled for entering this menu).
> 
> Correct

OK.

-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
