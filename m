Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422Ab3IZPlW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 11:41:22 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:54736 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832Ab3IZPlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 11:41:19 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpom3SkbGk-XgjXXFWZw2asAkxaM=XBYebWHxKQFN_WoXBw@mail.gmail.com>
References: <1379699036-7380-1-git-send-email-yinghai@kernel.org>
	<CAE9FiQV+K9QSEiRMA8BtqC8k2OHm4aZWODNL+vgfFmpsuBfzQg@mail.gmail.com>
	<CAKohpom3SkbGk-XgjXXFWZw2asAkxaM=XBYebWHxKQFN_WoXBw@mail.gmail.com>
Date: Thu, 26 Sep 2013 08:41:18 -0700
X-Google-Sender-Auth: 9UiwR5A77gke7hunhpqJFDj_Os0
Message-ID: <CAE9FiQUtZAe2Y1CUNKYRsSV3UM4g2N67EP5cAEcX7C786bXcaQ@mail.gmail.com>
Subject: Re: [PATCH -v2] cpufreq: skip loading acpi_cpufreq after intel_pstate
From: Yinghai Lu <yinghai@kernel.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 10:40 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 26 September 2013 10:47, Yinghai Lu <yinghai@kernel.org> wrote:
>> can you put this one in acpi tree?
>
> Its already applied in Rafael's linux-next branch.. Do you want something
> else?

sorry, I missed that.

I still had that in local patches directory, but looks like quilt is
not smart enough and did not report that patch is already applied.

Thanks

Yinghai
