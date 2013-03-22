Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751809Ab3CVASk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 20:18:40 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:44433 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab3CVASi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 20:18:38 -0400
MIME-Version: 1.0
In-Reply-To: <1773787.ohbjPLoSz4@vostro.rjw.lan>
References: <1362987319-6369-1-git-send-email-silviupopescu1990@gmail.com>
	<1773787.ohbjPLoSz4@vostro.rjw.lan>
Date: Fri, 22 Mar 2013 02:18:38 +0200
Message-ID: <CAPWTe+J4kduwxEgqMrKuZE48NMRzqYzeRUWXJMAmp4Dw=aEGtg@mail.gmail.com>
Subject: Re: [PATCH] kirkwood: fix coccicheck warnings
From: Silviu Popescu <silviupopescu1990@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Zhang Rui <rui.zhang@intel.com>, andrew@lunn.ch, jason@lakedaemon.net,
        rob.lee@linaro.org, len.brown@intel.com, khilman@ti.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 22, 2013 at 1:48 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Monday, March 11, 2013 09:35:19 AM Silviu-Mihai Popescu wrote:
>> Convert all uses of devm_request_and_ioremap() to the newly introduced
>> devm_ioremap_resource() which provides more consistent error handling.
>>
>> devm_ioremap_resource() provides its own error messages so all explicit
>> error messages can be removed from the failure code paths.
>>
>> Signed-off-by: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
>
> If I'm supposed to take these changes, please split them into separate patches
> for cpufreq, cpuidle and thermal (which would be for Rui BTW).

There seems to be an existing patch for thermal[1], as Rui pointed out himself.
I have split the changes in two patches, as you have requested, and resent them.

[1] http://marc.info/?l=linux-pm&m=136238017027514&w=2

Thanks,
Silviu Popescu
