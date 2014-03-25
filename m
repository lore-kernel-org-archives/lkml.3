Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703AbaCYJ7p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 05:59:45 -0400
Received: from service87.mimecast.com ([91.220.42.44]:38239 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbaCYJ7o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 05:59:44 -0400
Message-ID: <533153BF.3070308@arm.com>
Date: Tue, 25 Mar 2014 10:00:31 +0000
From: Sudeep Holla <sudeep.holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Hanjun Guo <hanjun.guo@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>
CC: Sudeep Holla <sudeep.holla@arm.com>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Brown <broonie@linaro.org>
Subject: Re: [Linaro-acpi] [PATCH] arm64: Fix duplicated Kconfig entries again
References: <1395738060-18489-1-git-send-email-hanjun.guo@linaro.org>
In-Reply-To: <1395738060-18489-1-git-send-email-hanjun.guo@linaro.org>
X-OriginalArrivalTime: 25 Mar 2014 09:59:54.0793 (UTC) FILETIME=[F8CD8990:01CF4810]
X-MC-Unique: 114032509594122601
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hanjun,

On 25/03/14 09:00, Hanjun Guo wrote:
> After commit 74397174989e5 (arm64: Fix duplicated Kconfig entries),
> I still get a duplicate Power management options section in linux-next
> git repo, may be due to some merge conflicts, anyway, fix that in this
> patch.
> 
I reported this and Mark Brown posted the patch[1].
I assumed it is already pulled, but looks like that's not the case.

Regards,
Sudeep

[1] http://www.spinics.net/lists/arm-kernel/msg314472.html

