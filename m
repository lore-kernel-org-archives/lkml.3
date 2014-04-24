Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758806AbaDXWgk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 18:36:40 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:54768 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756258AbaDXWf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 18:35:57 -0400
MIME-Version: 1.0
In-Reply-To: <CAPDyKFpZ_0U+y=ho8c4nmaoT3cB-v6+cwsWm0O8TrTrL-yHzCg@mail.gmail.com>
References: <1397782021-31396-1-git-send-email-tim.kryger@linaro.org>
	<CAPDyKFpZ_0U+y=ho8c4nmaoT3cB-v6+cwsWm0O8TrTrL-yHzCg@mail.gmail.com>
Date: Thu, 24 Apr 2014 15:35:55 -0700
Message-ID: <CAAYSxhpvT4CcwgKvefZFHeQ6YjVSyoCtgCv4ZMB==O5CMP+usg@mail.gmail.com>
Subject: Re: [PATCH 0/2] SDHCI should use more common MMC structs and functions
From: Tim Kryger <tim.kryger@linaro.org>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Chris Ball <chris@printf.net>, Mike Looijmans <mike.looijmans@topic.nl>,
        Andrew Bresticker <abrestic@chromium.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 1:34 AM, Ulf Hansson <ulf.hansson@linaro.org> wrote:
> On 18 April 2014 02:46, Tim Kryger <tim.kryger@linaro.org> wrote:
>> This series updates SDHCI to use the common regulator infrastructure that mmc
>> core provides.
>>
>> Tim Kryger (2):
>>   mmc: sdhci: Use supplies in common mmc_host struct
>>   mmc: sdhci: Use common mmc_regulator_get_supply
>
> Both patches looks good, but I would prefer if you could squash them
> into one patch.

Sure.
