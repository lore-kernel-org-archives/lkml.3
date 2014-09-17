Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240AbaIQXXd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 19:23:33 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:57349 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253AbaIQXXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 19:23:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Graeme Gregory <graeme.gregory@linaro.org>
Subject: Re: [PATCH v4 18/18] Documentation: ACPI for ARM64
Date: Thu, 18 Sep 2014 01:22:10 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Hanjun Guo <hanjun.guo@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <mark.rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Will Deacon <will.deacon@arm.com>, linaro-acpi@lists.linaro.org,
        Liviu Dudau <Liviu.Dudau@arm.com>, Lv Zheng <lv.zheng@intel.com>,
        Rob Herring <robh@kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Robert Moore <robert.moore@intel.com>, linux-acpi@vger.kernel.org,
        Charles.Garcia-Tobin@arm.com, Robert Richter <rric@kernel.org>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>, Jon Masters <jcm@redhat.com>,
        Mark Brown <broonie@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        Sudeep Holla <Sudeep.Holla@arm.com>
References: <1410530416-30200-1-git-send-email-hanjun.guo@linaro.org> <20140917014410.GC31214@srcf.ucam.org> <20140917160508.GA2464@xora-yoga-13>
In-Reply-To: <20140917160508.GA2464@xora-yoga-13>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201409180122.10631.arnd@arndb.de>
X-Provags-ID: V02:K0:51gJCs6Z/mMveK4qASC5XvhspmdjIYtIbTbp1mLr5lC
 H2S/4Ji5n5GmVC1heS+Rjtqt40pjfO3b5hbbWWpB97ppk1I18P
 zShGbkRrCCl+UFWFxvCnqpPGCwduQUPzLmjyv/WgfcvUqcLAO+
 ZZ/D+HIP6vD5xK3f5mDAEBiYT63uhxqMDgzkZ85NAQnOUbLhf2
 RUQoXW9QYRz6wmsEk24MUpRsJAI3Km40FsnKAlzkccc+gsmSxy
 xboZzzT/khL4QxxEjK7zChKi45Oqx/Yq0z9lWpmnVxPhr90076
 YNUPJ6504GjxGK28RqJLMmYeTSAXk9Dz2Qwq4YCXAU3Etyl1L3
 wq40rBHMD8I0SOSvAmns=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 September 2014, Graeme Gregory wrote:
> It sounds like from the discussions in other threads that ARM64 should
> be following x86 and re-using DT bindings here. In which case there is
> not need to submit things to UEFI organisation.
> 
> What I got a little lost in has there been a formal decision about DT
> bindings in _DSD?

I think this is a discussion that still needs to happen: either we should
recommend everyone to use _DSD in favor of the alternatives, or we
should prohibit the use of _DSD. I have heard arguments both ways, but
hopefully we can find an easy answer.

	Arnd
