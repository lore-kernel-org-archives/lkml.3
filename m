Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288Ab3FZI6I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 04:58:08 -0400
Received: from vaxjo.synopsys.com ([198.182.60.75]:38279 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756Ab3FZI6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 04:58:02 -0400
Message-ID: <51CAAD06.5080800@synopsys.com>
Date: Wed, 26 Jun 2013 14:27:42 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Christian Ruppert <christian.ruppert@abilis.com>
CC: Wolfram Sang <wsa@the-dreams.de>, Rob Herring <robherring2@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        <linux-i2c@vger.kernel.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>
Subject: Re: [PATCH v10] i2c-designware: make SDA hold time configurable
References: <20130625163902.GA2973@katana> <1372236906-6933-1-git-send-email-christian.ruppert@abilis.com>
In-Reply-To: <1372236906-6933-1-git-send-email-christian.ruppert@abilis.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.141]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2013 02:25 PM, Christian Ruppert wrote:
> This patch makes the SDA hold time configurable through device tree.
>
> Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
> Signed-off-by: Pierrick Hascoet <pierrick.hascoet@abilis.com>
> ---
>  .../devicetree/bindings/i2c/i2c-designware.txt     |   15 +++++++++++++++
>  arch/arc/boot/dts/abilis_tb100_dvk.dts             |   10 +++++-----
>  arch/arc/boot/dts/abilis_tb101_dvk.dts             |   10 +++++-----
>  drivers/i2c/busses/i2c-designware-core.c           |   13 +++++++++++++
>  drivers/i2c/busses/i2c-designware-core.h           |    1 +
>  drivers/i2c/busses/i2c-designware-platdrv.c        |   10 ++++++++++
>  6 files changed, 49 insertions(+), 10 deletions(-)

Acked-by: Vineet Gupta <vgupta@synopsys.com> for arch/arc bits

-Vineet
