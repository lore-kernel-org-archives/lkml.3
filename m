Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934704AbaDJGvo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 02:51:44 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:48342 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933461AbaDJGvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 02:51:42 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-fe-53463f78631f
Message-id: <1397112697.6717.2.camel@AMDC1943>
Subject: Re: [PATCH v4 00/16] mfd: max14577: Add support for MAX77836
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Date: Thu, 10 Apr 2014 08:51:37 +0200
In-reply-to: <53461E09.7090408@samsung.com>
References: <1393236641-14977-1-git-send-email-k.kozlowski@samsung.com>
 <53461E09.7090408@samsung.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.8.4-0ubuntu1
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsVy+t/xq7oV9m7BBg9nWFpsnLGe1WLqwyds
	Fte/PGe1mPTkPbPFxJWTmS3ONr1ht7j/9SijxabH11gtLu+aw2ax9shddovT3awW62e8ZnHg
	8dg56y67x+YVWh6bVnWyedy5tofNY97JQI/NS+o9+rasYvT4vEkugCOKyyYlNSezLLVI3y6B
	K+P88YnMBX16Fbf2fGdtYNyv3MXIySEhYCJxbf9DVghbTOLCvfVsXYxcHEICSxklDm2YzA7h
	fGaUODr3GAtIFa+AnsSc3WuYQGxhAVeJSd1nwWw2AWOJzcuXsIHYIgIaEjP/XmEEaWYWOMIs
	ce3QPHaQBIuAqsTbC+sZQWxOAW2JNXcmgA0VEsiQuLZwN1gzs4C6xKR5i5ghTlKSOLduDSPE
	YkGJH5PvsUDUyEtsXvOWeQKjwCwkLbOQlM1CUraAkXkVo2hqaXJBcVJ6rpFecWJucWleul5y
	fu4mRkjEfN3BuPSY1SFGAQ5GJR7eA8tcg4VYE8uKK3MPMUpwMCuJ8CoIuQUL8aYkVlalFuXH
	F5XmpBYfYmTi4JRqYBRT0/ow2yM6ffu0m8kmmTEf+MrMf1mm7/h0dubZgtikidN1Z3hXdCy0
	YnS1+h6S0tVr+Pv/lhIpo57kqITep8xNigsWtBkm7bgRs7dlffnzwpfnj2cr6HgfXG4awn69
	yK2RqdwufomdSstUx0VzFOxfF9YEliUlPJr1dD/TznjNicsifm/apsRSnJFoqMVcVJwIAGKs
	h/Z2AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czw, 2014-04-10 at 13:28 +0900, Chanwoo Choi wrote:
> Hi Krzysztof,
> 
> Did you finish this patchset for applying git repository?
> I can't find this patchset on mainline kernel.
> 
> If this patchset isn't applied on mainline, I'd like you to finish this patch
> because I want to maintain up to date patch for max77836/max14577 on mainline.

Hi,

The patches didn't get to mainline. I couldn't obtain all needed acks. I
prepared another version of the patchset (with less cross-subsystem
renames) which I plan to send after 3.15 merge window.

Best regards,
Krzysztof


> Thanks,
> Chanwoo Choi
> 
> On 02/24/2014 07:10 PM, Krzysztof Kozlowski wrote:
> > Hi,
> > 
> > 
> > This is fourth version of patchset adding support for MAX77836 device
> > to the max14577 driver.
> > 
> > Lee Jones suggested that after obtaining acks from all maintainers he can
> > merged these patches to his tree. These patches touch different subsystems
> > (charger/power, regulator, extcon and mfd) so this would be probably the best
> > way to merge everything. I would be glad if I could get missing acks
> > (or comments).
> > 
> > 
> > Changes since v3
> > ================
> > 1. Applied minor fixes (pointed by Lee Jones).
> > 2. Added one ACK (Lee Jones) and Review-by (Tomasz Figa).
> > 3. Patch 14/charger: Minor change in parsing EOC value from DTS.
> > 4. Rebased on next-20140224.
> > 
> > Changes since v2
> > ================
> > 1. Added ACK-s.
> > 2. Applied minor checkpatch fixes (pointed by Lee Jones).
> > 3. Rebased on next-20140217.
> > 
> > Changes since v1
> > ================
> > 1. Added ACK-s, reviews and tested-by tags.
> > 2. Removed applied patches (they were merged to the linux-next tree).
> > 3. Applied comments from review (Lee Jones) to 5/15 (detection of device type)
> >    and 8/15 (add max77836 support to max14577).
> > 4. Rebased on next tree.
> > 5. Added patch 13 and 14 (pointed by Jenny Tc):
> >    - regulator/mfd: max14577: Export symbols for calculating charger current
> >    - charger: max14577: Configure battery-dependent settings from DTS
> > 6. Updated bindings documentation with new charger bindings.
> > Previous thread:
> >  - [PATCH 00/18] mfd: max14577: Add support for MAX77836
> >    http://thread.gmane.org/gmane.linux.kernel/1636654/focus=1636674
> > 
> > 
> > Description
> > ===========
> > The MAX77836 is almost the same as MAX14577. Basically it is an extended
> > version of MAX14577. The chipsets have same MUIC component so the extcon,
> > charger and regulators require only little adjustments. More changes were
> > needed in the charger (because it uses lower charging current) and regulator
> > drivers (because mentioned different charing current and additional
> > regulators). The MAX77836 has also PMIC and Fuel Gauge (which is the same
> > as MAX17040/17048 Fuel Gauge).
> > 
> > The MAX77836 uses three I2C slave addresses and has additional interrupts
> > (related to PMIC and Fuel Gauge). It has also Interrupt Source register,
> > just like MAX77686 and MAX77693.
> > 
> > The patchset is organized in following way:
> > 1. Patches from 1 to 7 prepare the driver for supporting MAX77836. They
> >    mostly rename symbols and add additional logic related to different
> >    device types.
> > 2. Patches from 8 to 12 add support for MAX77836.
> > 3. Patches 13 and 14 remove hard-coded charger configuration with DTS. They
> >    were added after review on mailing lists.
> > 4. Patch 15 adds bindings documentation, which was not merged previously.
> > 5. Patch 16 adds SUSPEND mode to the regulator driver.
> > 
> > 
> > The patchset is based on linux-next tree and depends on patches from previous
> > release which are already merged into next.
> > Testing was done on 3.10.
> > 
> > 
> > TODO: Merge max14577, max77686 and max77693 into one common driver. They are
> > very similar.
> > 
> > 
> > Best regards,
> > Krzysztof Kozlowski
> > 
> > 
> > Chanwoo Choi (1):
> >   extcon: max14577: Change extcon name instead of static name according
> >     to device type
> > 
> > Krzysztof Kozlowski (15):
> >   mfd: max14577: Rename and add MAX14577 symbols to prepare for
> >     max77836
> >   mfd: max14577: Rename state container to maxim_core
> >   mfd: max14577: Add "muic" suffix to regmap and irq_chip
> >   mfd: max14577: Add detection of device type
> >   extcon: max14577: Add max14577 prefix to muic_irqs
> >   extcon: max14577: Choose muic_irqs according to device type
> >   mfd: max77836: Add max77836 support to max14577 driver
> >   extcon: max14577: Add support for max77836
> >   regulator: max14577: Add support for max77836 regulators
> >   charger: max14577: Add support for MAX77836 charger
> >   power: max17040: Add ID for max77836 Fuel Gauge block
> >   regulator/mfd: max14577: Export symbols for calculating charger
> >     current
> >   charger: max14577: Configure battery-dependent settings from DTS
> >   mfd: max14577: Add device tree bindings document
> >   regulator: max14577: Implement SUSPEND mode for MAX77836 LDO-s
> > 
> >  Documentation/devicetree/bindings/mfd/max14577.txt |  149 +++++
> >  drivers/extcon/extcon-max14577.c                   |  274 +++++----
> >  drivers/mfd/max14577.c                             |  475 +++++++++++++---
> >  drivers/power/max14577_charger.c                   |  361 +++++++++---
> >  drivers/power/max17040_battery.c                   |    1 +
> >  drivers/regulator/max14577.c                       |  334 ++++++++---
> >  include/linux/mfd/max14577-private.h               |  586 ++++++++++++--------
> >  include/linux/mfd/max14577.h                       |   50 +-
> >  8 files changed, 1697 insertions(+), 533 deletions(-)
> >  create mode 100644 Documentation/devicetree/bindings/mfd/max14577.txt
> > 

