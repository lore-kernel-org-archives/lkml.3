Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763631Ab3DDGZ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 02:25:59 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:58707 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763615Ab3DDGZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 02:25:57 -0400
MIME-Version: 1.0
In-Reply-To: <1364985034.16520.12.camel@pasglop>
References: <cover.1364229828.git.viresh.kumar@linaro.org>
	<4180fd5b43906421fc155126e8b7bea5fb3ff375.1364229828.git.viresh.kumar@linaro.org>
	<CAKohpo=LOJ3DfaGzCm6a6ev2+dNUgEpJd+04pGMhdSpkyZNR9A@mail.gmail.com>
	<CAKohpomRMkKouiy+iJUiheTcPGCDVLbxppL5f4oc-WMu2E5T8g@mail.gmail.com>
	<1364985034.16520.12.camel@pasglop>
Date: Thu, 4 Apr 2013 11:55:56 +0530
Message-ID: <CAKohpo=EPbGocbNaZcNtGuZy4Tst5jH4rPviQ6L=YuZceDnKMw@mail.gmail.com>
Subject: Re: [PATCH 9/9] powerpc: cpufreq: move cpufreq driver to drivers/cpufreq
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Olof Johansson <olof@lixom.net>, linuxppc-dev@lists.ozlabs.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: arvind.chauhan@arm.com, Arnd Bergmann <arnd.bergmann@linaro.org>,
        robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 April 2013 16:00, Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> On Wed, 2013-04-03 at 15:00 +0530, Viresh Kumar wrote:
>> On 31 March 2013 09:33, Viresh Kumar <viresh.kumar@linaro.org> wrote:

>> > Benjamin/Paul/Olof,
>> >
>> > Any comments on this?
>>
>> Ping!!
>
> I'm on vacation until end of April. No objection to the patch but
> somebody needs to test it.

Hi,

Can somebody else from powerpc world give it a try?

OR

@Rafael: Can we get this pushed in linux-next as is and then people would
be forced to test it and in case there are any complains, i will fix them or
you can revert it?
