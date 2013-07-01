Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890Ab3GALQg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 07:16:36 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:44786 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753346Ab3GALQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 07:16:35 -0400
Message-ID: <51D16501.3090303@ti.com>
Date: Mon, 1 Jul 2013 16:46:17 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: "J, KEERTHY" <j-keerthy@ti.com>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "ldewangan@nvidia.com" <ldewangan@nvidia.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] regulator: palmas: model SMPS10 as two regulators
References: <1372672182-14778-1-git-send-email-kishon@ti.com> <20130701100136.GA27646@sirena.org.uk> <51D1548E.4080008@ti.com> <DC88CAD03C0052499C1907B327FC63229F0F8A@DBDE04.ent.ti.com> <20130701110427.GJ27646@sirena.org.uk>
In-Reply-To: <20130701110427.GJ27646@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 July 2013 04:34 PM, Mark Brown wrote:
> On Mon, Jul 01, 2013 at 10:19:55AM +0000, J, KEERTHY wrote:
>
>> I had submitted a patch on the same file which was pulled by Samuel.
>> Kishon is based on a branch which has my patch. I think that is missing in your
>> Branch. This is the reason why it is not applying.
>
> OK, resend after -rc1.  Please also roll in Axel's fix.

Sure. Thanks.

-Kishon
