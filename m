Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837AbaJQTX1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 15:23:27 -0400
Received: from mga14.intel.com ([192.55.52.115]:7522 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753298AbaJQTXZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 15:23:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="401998577"
Message-ID: <54416CA2.2010701@linux.intel.com>
Date: Fri, 17 Oct 2014 21:23:14 +0200
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>, devicetree@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v5 00/12] Add ACPI _DSD and unified device properties
 support
References: <2660541.BycO7TFnA2@vostro.rjw.lan> <11223831.j9KAEfSQsY@vostro.rjw.lan> <20141017154007.GB29643@kroah.com>
In-Reply-To: <20141017154007.GB29643@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10/17/14 17:40, Greg Kroah-Hartman wrote:
> On Fri, Oct 17, 2014 at 02:01:33PM +0200, Rafael J. Wysocki wrote:
>> Hi Everyone,
>>
>> Hving had a couple of chats with Grant and Arnd during LinuxCon EU/LPC, we
>> now have version 5 taking all feedback into account (hopefully).
>>
>> Changes have been made to patch [02/12] and to patches [09-12/12], although
>> in patches [10-12/12] they are fairly minor.  I have retained the Greg's
>> ACK on patch [02/12], because it is essentially the same that have been
>> posted aleady and ACKed by him (Greg, please let me know if I shouldn't
>> do that) and all the ACKs on the remaining patches except for patch [09/12]
>> which is substantially different.  Still, if reviewers think that their
>> ACKs don't apply any more, please let me know and I'll remove them.
> 
> No objection from me to keep my ACK on those patches, thanks for asking.
> 
> greg k-h
> 

Mine certainly still apply as well.

-- 
Darren Hart
Intel Open Source Technology Center
