Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945Ab3FJNUu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 09:20:50 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:55173 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250Ab3FJNUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 09:20:48 -0400
X-AuditID: cbfee61b-b7f8e6d00000524c-00-51b5d2aee2d5
Date: Mon, 10 Jun 2013 15:20:27 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Borislav Petkov <bp@alien8.de>, Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocky" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH 5/5] cpufreq:boost:Kconfig: Enable boost support at Kconfig
Message-id: <20130610152027.3133d1ab@amdc308.digital.local>
In-reply-to: <20130606155815.GB21272@pd.tnic>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1370502472-7249-6-git-send-email-l.majewski@samsung.com>
 <20130606155815.GB21272@pd.tnic>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmkeLIzCtJLcpLzFFi42I5/e+xoO66S1sDDb7flbH483Y5q8XnDf/Y
	LJ42/WC3mPdZ1qLz7BNmizePuC0u75rDZvG59wijxe3GFWwW/Qt7mSw6jnxjttj41cOBx+N7
	ax+Lx51re9g81k17y+zRt2UVo8ejxS2MHp83yQWwRXHZpKTmZJalFunbJXBldG5ezlhwgbXi
	9fJHTA2Mq1m6GDk5JARMJFatOMgKYYtJXLi3nq2LkYtDSGA6o8TJz1OYIZx2Jok9534xgVSx
	CKhK/J55FKyDTUBP4vPdp2BxEQEvic3nrrODNDALHGKWeDh1BhtIQljAX2LO8XXsIDavgLXE
	/YUHgWwODk4BXYkJM/1AwkICSxglWheog9j8ApIS7f9+MENcZCdx7tMGqFZBiR+T74FdzSyg
	JbF5WxMrhC0vsXnNW+YJjIKzkJTNQlI2C0nZAkbmVYyiqQXJBcVJ6blGesWJucWleel6yfm5
	mxjBUfNMegfjqgaLQ4wCHIxKPLwPfm0JFGJNLCuuzD3EKMHBrCTCK7tla6AQb0piZVVqUX58
	UWlOavEhRmkOFiVx3oOt1oFCAumJJanZqakFqUUwWSYOTqkGRunzVc88Wj22Vi7glL2Xoqks
	cH/tUYW+r9+8t2yu9XT0mHdovs28Pxwba5MnT7rwZa3F8g9zXA2P3dNI+uayoHedVzh/x7d7
	f8Lq82OiL58W0th5Zs1G9oJfT+ucmKaIbQtc/9H1ZaLhRYM9rm4ZewMVhJmP2S37uubV9ksT
	A70VJG8seiGmK63EUpyRaKjFXFScCAATZX/UlgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> On Thu, Jun 06, 2013 at 09:07:52AM +0200, Lukasz Majewski wrote:
> > Enable/disable support for BOOST. New flag - CPU_FREQ_BOOST has been
> > defined for that.
> 
> What's the reason for this? Why would you want to not compile-in the
> boosting code?

I think that this flag could be removed and the "boost" could be
compiled-in permanently.

Viresh, what is your opinion?

> 
> Also, at least on x86, even with this feature disabled, the CPU will
> boost by default unless you fiddle with it through the MSRs as root.
> 

So this is a good argument for removing this flag from Kconfig.


-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
