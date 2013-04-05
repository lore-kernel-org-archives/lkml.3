Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765960Ab3DEBRI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 21:17:08 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:33057 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765936Ab3DEBRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 21:17:05 -0400
MIME-Version: 1.0
In-Reply-To: <2724059.EMM6yAeBck@vostro.rjw.lan>
References: <cover.1365079581.git.viresh.kumar@linaro.org>
	<2724059.EMM6yAeBck@vostro.rjw.lan>
Date: Fri, 5 Apr 2013 06:47:03 +0530
Message-ID: <CAKohpom8=jn+i2VUEFwgRQDAwaxBT7rB-nHcY1rSE_BxW+VBmA@mail.gmail.com>
Subject: Re: [PATCH 00/18] For-3.10: CPUFreq: Move drivers to drivers/cpufreq
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 April 2013 04:06, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Thursday, April 04, 2013 06:24:08 PM Viresh Kumar wrote:
>> Hi Rafael,
>>
>> These are all the remaining patches i have for 3.10. All of them have received
>> Acks from their maintainers leaving powerpc ones. I have got an additional patch
>> for powerpc (18) this time, it was the only driver left out of drivers/cpufreq.
>>
>> Please consider them for applying to your bleeding-edge or linux-next.
>
> Patches [1-16/18] plus the fixed-up [18/18] (slightly modified due to the
> ordering change) applied to bleeding-edge.  For [17/18] I need an ACK from the
> powerpc side.

Thanks.
