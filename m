Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757119AbaHZDio (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 23:38:44 -0400
Received: from mga14.intel.com ([192.55.52.115]:57567 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755631AbaHZDin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 23:38:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,400,1406617200"; 
   d="scan'208";a="581646447"
User-Agent: Microsoft-MacOutlook/14.4.3.140616
Date: Mon, 25 Aug 2014 20:38:38 -0500
Subject: Re: [3.17 REGRESSION FIX] Revert "ideapad-laptop: Disable touchpad
 interface on Yoga models"
From: Darren Hart <dvhart@infradead.org>
To: Josh Boyer <jwboyer@fedoraproject.org>,
        Hans de Goede <hdegoede@redhat.com>
CC: Matthew Garrett <matthew.garrett@nebula.com>,
        Corentin Chary <corentin.chary@gmail.com>,
        GOESSEL Guillaume <g_goessel@outlook.com>,
        <platform-driver-x86@vger.kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Message-ID: <D0214EE1.A54F3%dvhart@linux.intel.com>
Thread-Topic: [3.17 REGRESSION FIX] Revert "ideapad-laptop: Disable touchpad
 interface on Yoga models"
References: <1408960813-12237-1-git-send-email-hdegoede@redhat.com>
 <CA+5PVA7pEwu4amAn+gH3TS-a6CvsSH=TyE+3k07Uoz9BpcpRMA@mail.gmail.com>
In-Reply-To: <CA+5PVA7pEwu4amAn+gH3TS-a6CvsSH=TyE+3k07Uoz9BpcpRMA@mail.gmail.com>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 6:44 AM, Josh Boyer <jwboyer@fedoraproject.org>
wrote:
> On Mon, Aug 25, 2014 at 6:00 AM, Hans de Goede <hdegoede@redhat.com>
>wrote:
>> I've received a bug report from a user that the touchpad control part
>> of the ideapad-laptop ACPI interface does work for him on his
>> "Lenovo Yoga 2 13", and that this patch causes a regression for him.
>>
>> Since it did not work for me when I had a "Lenovo Yoga 2 11" in my own
>> hands (loaned from a friend). It seems that this is a bit of hit and
>>miss.
>>
>> Since the result of having a false positive here is worse, then the
>>minor
>> annoyance of a false touchpad disabled messages being shown after
>>suspend /
>> resume on models (or is it firmware versions?) where the interface does
>>not
>> work, simply revert the patch.
>>
>> This reverts commit f79a901331a823ae370584b15cd39dd110b95a0a.

Appears to be the right call to me. Please give me a couple of days to get
trees mirrored and up to speed. I'll provide links to new trees and such
shortly.

>>
>> Reported-by: GOESSEL Guillaume <g_goessel@outlook.com>
>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>
> Adding Daren on CC.  He recently agreed to take over the platform
>drivers.
>

Thanks. I'm still sorting out my email situation for this role (apologies
for the last response to those getting this twice). I'll make that clear
in the maintainers patch to follow soon.

Thanks,


-- 
Darren Hart
Intel Open Source Technology Center


