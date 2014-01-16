Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724AbaAPVVQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 16:21:16 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:63169 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbaAPVVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 16:21:13 -0500
MIME-Version: 1.0
In-Reply-To: <744357E9AAD1214791ACBA4B0B909263011CE77F@SHSMSX101.ccr.corp.intel.com>
References: <1389689198-2641-1-git-send-email-rui.zhang@intel.com>
	<1389689198-2641-5-git-send-email-rui.zhang@intel.com>
	<CAL_JsqJFRQ+27N_9AwZXpx4V=g8HKn84WdVKtQ_Br_8SQTXY7g@mail.gmail.com>
	<744357E9AAD1214791ACBA4B0B909263011CE77F@SHSMSX101.ccr.corp.intel.com>
Date: Thu, 16 Jan 2014 15:21:12 -0600
Message-ID: <CAL_Jsq+uVs=pHqSaQcQY-TQNnkFJ1MWkZxfE1B3Oxjby7uqrmw@mail.gmail.com>
Subject: Re: [PATCH 4/4] OF: introduce OF style 'modalias' support for
 platform bus.
From: Rob Herring <robherring2@gmail.com>
To: "Zhang, Rui" <rui.zhang@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        "wsa@the-dreams.de" <wsa@the-dreams.de>,
        Mark Brown <broonie@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "jarkko.nikula@linux.intel.com" <jarkko.nikula@linux.intel.com>,
        "mika.westerberg@linux.intel.com" <mika.westerberg@linux.intel.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 1:04 AM, Zhang, Rui <rui.zhang@intel.com> wrote:
>
>
>> -----Original Message-----
>> From: Rob Herring [mailto:robherring2@gmail.com]
>> Sent: Wednesday, January 15, 2014 9:45 PM
>> To: Zhang, Rui
>> Cc: linux-kernel@vger.kernel.org; linux-acpi@vger.kernel.org; linux-
>> i2c@vger.kernel.org; linux-spi@vger.kernel.org; wsa@the-dreams.de; Mark
>> Brown; Greg Kroah-Hartman; Wysocki, Rafael J; Grant Likely; Rob Herring;
>> jarkko.nikula@linux.intel.com; mika.westerberg@linux.intel.com;
>> devicetree@vger.kernel.org
>> Subject: Re: [PATCH 4/4] OF: introduce OF style 'modalias' support for
>> platform bus.
>> Importance: High
>>
>> On Tue, Jan 14, 2014 at 2:46 AM, Zhang Rui <rui.zhang@intel.com> wrote:
>> > Fix a problem that, the platform bus supports the OF style modalias
>> in
>> > .uevent() call, but not in its device 'modalias' sysfs attribute.
>> >
>> > cc: devicetree@vger.kernel.org
>> > Signed-off-by: Zhang Rui <rui.zhang@intel.com>
>>
>> Acked-by: Rob Herring <robh@kernel.org>
>>
>> As there doesn't appear any dependency with the rest of this series, I
>> can take this.
>>
> Thanks.
>

Looks like there is actually a dependency in modalias_show, and the
comment about PAGE_SIZE would apply here too I think. So the whole
series should be taken together.

Rob
