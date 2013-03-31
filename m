Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730Ab3CaBln (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 21:41:43 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:48233 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754187Ab3CaBll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 21:41:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, arvind.chauhan@arm.com, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, jacob.shin@amd.com
Subject: Re: [PATCH V4 0/2] Implement per policy instance of governor
Date: Sun, 31 Mar 2013 03:49:13 +0200
Message-ID: <4183493.GBcPoVddxx@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAKohponaAyo2BL3X+rxNTO9-u88dfj7Vho6zRyUmvct6XyHyVw@mail.gmail.com>
References: <cover.1364398686.git.viresh.kumar@linaro.org> <1656173.qmCdUDP7Pu@vostro.rjw.lan> <CAKohponaAyo2BL3X+rxNTO9-u88dfj7Vho6zRyUmvct6XyHyVw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, March 31, 2013 07:00:16 AM Viresh Kumar wrote:
> On 31 March 2013 03:38, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > OK, I'll remove it.
> 
> Thanks.
> 
> > And by the way, I'm no longer amused with the mess going on in the cpufreq land.
> >
> > Please send me *patches*.  I'm not interested in git pointers.
> 
> Hmm.
> 
> > Moreover, please send those patches in a way allowing me to figure out the
> > ordering without looking into your git tree.
> 
> Yes, i was planning to do so.
> 
> > If you have a number of outstanding cpufreq patches for me to apply, please
> > create a patch series out of them and send it.
> 
> Do you mean, i should merge all stuff i have queued up for 3.10 in a
> single patchset?
> Like for-3.10? Will do.

Yes, thanks.

But the patches moving cpufreq drivers into drivers/cpufreq from somewhere else
need each an ACK from the maintainer of that other place.  I won't take any
patches like that without AKCs.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
