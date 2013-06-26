Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857Ab3FZEX5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 00:23:57 -0400
Received: from us01smtp2.synopsys.com ([198.182.44.80]:44349 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab3FZEXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 00:23:55 -0400
Message-ID: <51CA6CC8.6070305@synopsys.com>
Date: Wed, 26 Jun 2013 09:53:36 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: Christian Ruppert <christian.ruppert@abilis.com>,
        Rob Herring <robherring2@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        <linux-i2c@vger.kernel.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>
Subject: Re: [PATCH v9] i2c-designware: make SDA hold time configurable
References: <20130620203716.GF2961@katana> <1371808422-27742-1-git-send-email-christian.ruppert@abilis.com> <20130625163902.GA2973@katana>
In-Reply-To: <20130625163902.GA2973@katana>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.141]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2013 10:09 PM, Wolfram Sang wrote:
> Hi,
>
> On Fri, Jun 21, 2013 at 11:53:42AM +0200, Christian Ruppert wrote:
>> > This patch makes the SDA hold time configurable through device tree.
>> > 
>> > Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
>> > Signed-off-by: Pierrick Hascoet <pierrick.hascoet@abilis.com>
>> > ---
>> >  .../devicetree/bindings/i2c/i2c-designware.txt     |   14 ++++++++++++++
>> >  arch/arc/boot/dts/abilis_tb100_dvk.dts             |   10 +++++-----
>> >  arch/arc/boot/dts/abilis_tb101_dvk.dts             |   10 +++++-----
> Vineet, an ack for those would be nice since I think it is better if I
> take all this via I2C.
>

Certainly, I was waiting for you guys to converge :-)

Acked-by: Vineet Gupta <vgupta@synopsys.com>   # for arch/arc/boot/dts/*

-Vineet
