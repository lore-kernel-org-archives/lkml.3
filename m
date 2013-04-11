Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790Ab3DKHAA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 03:00:00 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:44528 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab3DKG76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 02:59:58 -0400
Date: Wed, 10 Apr 2013 23:59:57 -0700
From: Olof Johansson <olof@lixom.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linuxppc-dev@lists.ozlabs.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        arvind.chauhan@arm.com, Arnd Bergmann <arnd.bergmann@linaro.org>,
        robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 9/9] powerpc: cpufreq: move cpufreq driver to
 drivers/cpufreq
Message-ID: <20130411065957.GB31465@quad.lixom.net>
References: <cover.1364229828.git.viresh.kumar@linaro.org>
 <4180fd5b43906421fc155126e8b7bea5fb3ff375.1364229828.git.viresh.kumar@linaro.org>
 <CAKohpo=LOJ3DfaGzCm6a6ev2+dNUgEpJd+04pGMhdSpkyZNR9A@mail.gmail.com>
 <CAKohpomRMkKouiy+iJUiheTcPGCDVLbxppL5f4oc-WMu2E5T8g@mail.gmail.com>
 <1364985034.16520.12.camel@pasglop>
 <CAKohpo=EPbGocbNaZcNtGuZy4Tst5jH4rPviQ6L=YuZceDnKMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpo=EPbGocbNaZcNtGuZy4Tst5jH4rPviQ6L=YuZceDnKMw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 04, 2013 at 11:55:56AM +0530, Viresh Kumar wrote:
> On 3 April 2013 16:00, Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> > On Wed, 2013-04-03 at 15:00 +0530, Viresh Kumar wrote:
> >> On 31 March 2013 09:33, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> 
> >> > Benjamin/Paul/Olof,
> >> >
> >> > Any comments on this?
> >>
> >> Ping!!
> >
> > I'm on vacation until end of April. No objection to the patch but
> > somebody needs to test it.
> 
> Hi,
> 
> Can somebody else from powerpc world give it a try?
> 
> OR
> 
> @Rafael: Can we get this pushed in linux-next as is and then people would
> be forced to test it and in case there are any complains, i will fix them or
> you can revert it?


That's not very nice this late in the staging cycle. Give the powerpc
guys a little more time than a single day to come back with test results,
please.


-Olof
