Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026AbaJHKzS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 06:55:18 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:56969 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805AbaJHKzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 06:55:16 -0400
Message-ID: <543517F9.9070109@pivasoftware.com>
Date: Wed, 08 Oct 2014 11:54:49 +0100
From: Oussama Ghorbel <ghorbel@pivasoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Roger Quadros <rogerq@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>
CC: Rabin Vincent <rabin@rab.in>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] phy: omap-usb2: Enable runtime PM of omap-usb2 phy
 properly
References: <20141006194418.GA399@debian> <1412679771-8293-1-git-send-email-ghorbel@pivasoftware.com> <5434F336.4040908@ti.com>
In-Reply-To: <5434F336.4040908@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:gaMJmqXJJibIAkhu0qpCP+U09bKFjp5PO2PQsSjAC55
 Zis5P3eguuN6aGtGhOgS6vLGXtYacF4O+X3kNTEJScv2WEzLWI
 4ZXAcmF4JGbBnqGjai6A1iqkgoK9EG/QuISPESqEsVRasi5Tdf
 4kcsSXJ6x2GHQ7/NNUZOrc26xMyc1RE7lxQiy396uZ5Ge409LC
 Rqkwyu0+FHHEw5j1z2CB9qE3ODYAlj191Gl8xzrRa5e/EqQbwR
 Uvp+Z1QfGB7kppG1PS5KSsETH8Beq6ao/zaxbeb5xKhwatIiac
 Ec7QNpRNbkNerYLyrchih0UyA+4gKNqjskQ8YsWMJL8Csg+Ug6
 sZ5o9eNXaJmFFlBJyU+mZCKyMygkHkjai23c6sf+2
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roger,

Should I resend this v2 version of the patch to stable@vger.kernel.org 
which is suitable for v3.17 and which will require a very tiny adaptation?
Or I should resend the first version of this patch which is suitable for 
3.16 but might seems confusing a little sine I'm resend the outdated 
version.

Thanks,
Oussama
On 10/08/2014 09:17 AM, Roger Quadros wrote:
> Hi Oussama,
>
> On 10/07/2014 02:02 PM, Oussama Ghorbel wrote:
>> The USB OTG port does not work since v3.16 on omap platform.
>> This is a regression introduced by the commit
>> eb82a3d846fa (phy: omap-usb2: Balance pm_runtime_enable() on probe failure
>>   and remove).
>> This because the call to pm_runtime_enable() function is moved after the
>> call to devm_phy_create() function, which has side effect since later in
>> the subsequent calls of devm_phy_create() there is a check with
>> pm_runtime_enabled() to configure few things.
>>
>> Signed-off-by: Oussama Ghorbel <ghorbel@pivasoftware.com>
> Acked-by: Roger Quadros <rogerq@ti.com>
>
> Could you please send the patch to
> Cc: <stable@vger.kernel.org>        [3.16+]
>
> That way it will get into 3.16 onwards. Thanks.
>
> cheers,
> -roger
>

