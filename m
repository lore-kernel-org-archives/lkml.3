Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946AbaIXImr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 04:42:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:40976 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753557AbaIXImo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 04:42:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,587,1406617200"; 
   d="scan'208";a="604535605"
Message-ID: <5422845C.1000909@intel.com>
Date: Wed, 24 Sep 2014 10:44:12 +0200
From: Loic Poulain <loic.poulain@intel.com>
Organization: Intel Corporation SAS - RCS Nanterre B 302 456 199 - 2 rue de
 Paris, 92196 Meudon Cedex, France 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "Westerberg, Mika" <mika.westerberg@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>
CC: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Samuel Ortiz <samuel.ortiz@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2] pinctrl: baytrail: Clear DIRECT_IRQ bit
References: <1410961621-15231-1-git-send-email-loic.poulain@intel.com> <CACRpkdYfMNVeK_X_oQFTnDwyZ_ZemUw3SBL0_JJvpToRXgdFSg@mail.gmail.com> <20140923183629.GU1786@lahna.fi.intel.com>
In-Reply-To: <20140923183629.GU1786@lahna.fi.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes I'm going to do a v3.

Regards,
Loic

On 23/09/2014 20:36, Westerberg, Mika wrote:
> On Tue, Sep 23, 2014 at 05:44:43PM +0200, Linus Walleij wrote:
>> On Wed, Sep 17, 2014 at 3:47 PM, Loic Poulain <loic.poulain@intel.com> wrote:
>>
>>> Direct Irq En bit can be initialized to a bad value.
>>> This bit has to be cleared for io access mode.
>>>
>>> Signed-off-by: Loic Poulain <loic.poulain@intel.com>
>>> ---
>>>   v2: Apply over ff998356b644ebe723127bd9eec6040b59a4a4f6 + add Warning
>> I can't figure out if the maintainers like this patch or not.
>>
>> If you want it applied, please ACK it explicitly.
> I would like to get a bit better information in the changelog and the
> warning message should be more informative. I'll ACK it after that is
> done.
>
> Loic, are you going to do that?

-- 
Intel Open Source Technology Center
http://oss.intel.com/

