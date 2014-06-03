Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151AbaFCKIU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 06:08:20 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:52771 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbaFCKIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 06:08:17 -0400
MIME-Version: 1.0
In-Reply-To: <538D9DBD.2030605@linux.vnet.ibm.com>
References: <20140526205337.1100.55275.stgit@srivatsabhat.in.ibm.com>
	<CAKohpokdnHag=79cXuwgNjX-k+JJU9GE3KUBhixcj3PZ6y78GQ@mail.gmail.com>
	<538D9631.9090500@linux.vnet.ibm.com>
	<CAKohpomynD9m-Cq4zsVSp3Xbw5Tx2cSe_Fcp5y0U8uAKSpQ1Tw@mail.gmail.com>
	<538D9DBD.2030605@linux.vnet.ibm.com>
Date: Tue, 3 Jun 2014 15:38:17 +0530
Message-ID: <CAKohpomS+ayvCavhXMHubcx2Pn6NcTDkV5iyUV+nz6_fKJetDg@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: governor: Be friendly towards latency-sensitive
 bursty workloads
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        "ego@linux.vnet.ibm.com" <ego@linux.vnet.ibm.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 June 2014 15:34, Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com> wrote:
> Well, the method I used keeps the organization such that the code following
> the comment does precisely what the comment says (i.e, get the sampling_rate,
> fetch the multiplier, and then multiply). So I feel it makes it easier to
> understand.

It looked like the comment is there only for this special statement:

>>> +               sampling_rate *= od_dbs_info->rate_mult;

And so suggested that :)

Anyway move this up as it doesn't belong to comment for sure.
>> +               od_dbs_info = dbs_data->cdata->get_cpu_dbs_info_s(cpu);
