Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099Ab3KTPyx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 10:54:53 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:45760 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060Ab3KTPyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 10:54:49 -0500
Message-ID: <528CDB1C.1010806@ti.com>
Date: Wed, 20 Nov 2013 17:54:04 +0200
From: "ivan.khoronzhuk" <ivan.khoronzhuk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
CC: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, <devicetree@vger.kernel.org>,
        <grygorii.strashko@ti.com>, Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@kernel.crashing.org>,
        Rob Herring <rob.herring@calxeda.com>, <linux-kernel@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>
Subject: Re: [PATCH 6/7] mtd: nand: davinci: extend description of bindings
References: <1384960945-14528-1-git-send-email-ivan.khoronzhuk@ti.com> <1384960945-14528-7-git-send-email-ivan.khoronzhuk@ti.com> <201311201646.21435.arnd@arndb.de>
In-Reply-To: <201311201646.21435.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.145.122]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2013 05:46 PM, Arnd Bergmann wrote:
> On Wednesday 20 November 2013, Ivan Khoronzhuk wrote:
>> Extend bindings for davinci_nand driver to be more clear.
>>
>> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
>> ---
>>   .../devicetree/bindings/mtd/davinci-nand.txt       |   77 ++++++++++++++------
>>   1 file changed, 54 insertions(+), 23 deletions(-)
>
> Hi Ivan,
>
> The changes look good to me, but please clarify in the changeset description
> above whether this is a backwards-compatible change, a clarification without
> semantic changes, or an incompatible change (which should be avoided).
>
> 	Arnd
>

This is a clarification only, without semantic changes.
Thanks, I'll update.

-- 
Regards,
Ivan Khoronzhuk
