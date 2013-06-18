Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963Ab3FRKc0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 06:32:26 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:54601 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905Ab3FRKcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 06:32:24 -0400
MIME-Version: 1.0
In-Reply-To: <51BF77C2.70004@gmail.com>
References: <20130514110745.GA10906@intel.com>
	<1368536642-7158-1-git-send-email-christian.ruppert@abilis.com>
	<51BF77C2.70004@gmail.com>
Date: Tue, 18 Jun 2013 13:32:23 +0300
Message-ID: <CAHp75VfgJ805yaM6mOf-H3tA5jNhKpe4C1SxL2yrvoe_h6jKzw@mail.gmail.com>
Subject: Re: [PATCH REBASE] i2c-designware: make SDA hold time configurable
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Christian Ruppert <christian.ruppert@abilis.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-i2c@vger.kernel.org,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 11:55 PM, Rob Herring <robherring2@gmail.com> wrote:

>> +Optional properties :
>> + - sda-hold-time : should contain the SDA hold time in nanoseconds.
>
> Please specify time units in the property name. Perhaps
> i2c-sda-hold-time-ns.
>
> Based on reading the discussion, there is one similar property I have
> found: "samsung,i2c-sda-delay = <100>". I wouldn't copy it as it doesn't
> tell the units or what the delay is.

Often on of the painful issues with DT models is the absence of the properties.
Should someone create the property definition first under
Documentation and _then_ patch everything around?
(Though I think better to think and create documents first and after
program accordingly)

--
With Best Regards,
Andy Shevchenko
