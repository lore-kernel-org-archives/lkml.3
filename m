Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab3I0MOG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 08:14:06 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:64450 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440Ab3I0MOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 08:14:03 -0400
MIME-Version: 1.0
In-Reply-To: <52454608.6040504@linaro.org>
References: <1380248694-13388-1-git-send-email-robherring2@gmail.com>
	<1380248694-13388-4-git-send-email-robherring2@gmail.com>
	<52454608.6040504@linaro.org>
Date: Fri, 27 Sep 2013 07:14:02 -0500
Message-ID: <CAL_JsqL=L8rZ_2qExR0rWV2Z_OQM-w0vHJhx-Xtid-ozAqghUA@mail.gmail.com>
Subject: Re: [PATCH 3/6] cpuidle: calxeda: add ecx-2000 support
From: Rob Herring <robherring2@gmail.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 3:47 AM, Daniel Lezcano
<daniel.lezcano@linaro.org> wrote:
> On 09/27/2013 04:24 AM, Rob Herring wrote:
>>
>> From: Rob Herring <rob.herring@calxeda.com>
>>
>> Add cpuidle support for Calxeda ecx-2000 SoC.
>>
>> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
>> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
>> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
>> Cc: linux-pm@vger.kernel.org
>
>
> Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>

Thanks.

> Shall I pick these three patches in my tree ?

No, the highbank changes are dependent on this to go in first.

Rob
