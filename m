Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535AbaCZCbH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 22:31:07 -0400
Received: from mail-yh0-f43.google.com ([209.85.213.43]:36874 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755262AbaCZCbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 22:31:05 -0400
Message-ID: <53323BD6.2090107@linaro.org>
Date: Wed, 26 Mar 2014 10:30:46 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Zhang Rui <rui.zhang@intel.com>
CC: mark.hambleton@broadcom.com, mark.brown@linaro.org,
        eduardo.valentin@ti.com, mporter@linaro.org, lsk-interest@linaro.org,
        linaro-kernel@linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/19] thermal: allow registering without .get_temp
References: <1395744572-20014-1-git-send-email-alex.shi@linaro.org>	 <1395744572-20014-2-git-send-email-alex.shi@linaro.org> <1395800631.2330.8.camel@rzhang1-mobl4>
In-Reply-To: <1395800631.2330.8.camel@rzhang1-mobl4>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2014 10:23 AM, Zhang Rui wrote:
>> From: Eduardo Valentin <eduardo.valentin@ti.com>
>> > 
>> > This patch changes the thermal core driver to allow
>> > registration of thermal zones without the .get_temp callback.
>> > 
>> > The idea behind this change is to allow lazy registration
>> > of sensor callbacks.
>> > 
>> > The thermal zone will be disabled whenever the ops
>> > does not contain a .get_temp callback. The sysfs interface
>> > will be returning -EINVAL on any temperature read operation.
>> > 
>> > Cc: Zhang Rui <rui.zhang@intel.com>
>> > Cc: linux-pm@vger.kernel.org
>> > Cc: linux-kernel@vger.kernel.org
>> > Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
>> > (cherry picked from commit 81bd4e1cebed5efb85bd94a15342ee4d6965a416)
>> > 
>> > Signed-off-by: Alex Shi <alex.shi@linaro.org>
> why are you sending this patch series?
> all of the patches have been in upstream already.
> Plus, next time when you send a big patch set, please send with a patch
> 00/XX to give a general introduction of the whole patch set.
> 

We want to backport this patchset to linaro stable kernel which is based
on 3.10 kernel. git://git.linaro.org/kernel/linux-linaro-stable.git

It should not be spread this to community. Sorry, My fault!

-- 
Thanks
    Alex
