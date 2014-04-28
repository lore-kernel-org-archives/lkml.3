Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757093AbaD1Ucq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 16:32:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:52265 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752375AbaD1Ucp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 16:32:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,946,1389772800"; 
   d="scan'208";a="502495786"
Message-ID: <535EBAAE.5060309@intel.com>
Date: Mon, 28 Apr 2014 22:31:42 +0200
From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Organization: Intel Technology Poland Sp. z o. o., KRS 101882, ul. Slowackiego
 173, 80-298 Gdansk
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Zhang Rui <rui.zhang@intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, matthew.garrett@nebula.com,
        dmitry.torokhov@gmail.com
Subject: Re: [PATCH V5 09/12] ACPI: introduce acpi platform exclude id list
References: <1396886819-2637-1-git-send-email-rui.zhang@intel.com>	 <1396886819-2637-10-git-send-email-rui.zhang@intel.com>	 <5562797.vTJauiAbJc@vostro.rjw.lan> <1398650223.2443.12.camel@rzhang1-mobl4>
In-Reply-To: <1398650223.2443.12.camel@rzhang1-mobl4>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/28/2014 3:57 AM, Zhang Rui wrote:
> On Mon, 2014-04-28 at 00:21 +0200, Rafael J. Wysocki wrote:
>> On Tuesday, April 08, 2014 12:06:56 AM Zhang Rui wrote:
>>> For ACPI PIC (PNP0000) and Timer (PNP0100) device objects, although
>>> they have _HID control method, but they should not be enumerated to
>>> platform bus, because there will never be any platform drivers for them.
>>>
>>> Thus an exclude id list is introduced in this patch to prevent
>>> those platform device nodes from being created.
>>>
>>> Signed-off-by: Zhang Rui <rui.zhang@intel.com>
>> This should go into [6/12] as well.
>>
> I think it is okay to keep them as separate patches because they do not
> break bisect. And this patch is just a cleanup, it does not fix a real
> BUG in patch 6/12.

OK

