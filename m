Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984Ab3KNR1U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 12:27:20 -0500
Received: from mga14.intel.com ([143.182.124.37]:37020 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754408Ab3KNR1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 12:27:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="320883193"
Message-ID: <528508FA.5040109@linux.intel.com>
Date: Thu, 14 Nov 2013 09:31:38 -0800
From: David Cohen <david.a.cohen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: matthew.garrett@nebula.com, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org, eric.ernst@linux.intel.com,
        Kuppuswamy Sathyanarayanan 
	<sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: Re: [PATCH 2/3] ipc: Enabled ipc support for additional intel platforms
References: <1384373671-12814-1-git-send-email-david.a.cohen@linux.intel.com> <1384373671-12814-3-git-send-email-david.a.cohen@linux.intel.com> <20131114134311.01d24bc5@alan.etchedpixels.co.uk>
In-Reply-To: <20131114134311.01d24bc5@alan.etchedpixels.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2013 05:43 AM, One Thousand Gnomes wrote:
> On Wed, 13 Nov 2013 12:14:30 -0800
> David Cohen <david.a.cohen@linux.intel.com> wrote:
>
>> From: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
>>
>> Enabled ipc support for penwell, clovertrail & tangier platforms.
>
> At some point this really ought to be discoverable in your SFI, ACPI or
> similar data tables not continually hard coded.

Agreed. But it depends on fw changes, which I believe to happen on
newer platforms only. On driver side we need to fill the missing
resource info with hardcoded values :/

Br, David
