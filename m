Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758814AbaIOVCK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 17:02:10 -0400
Received: from mga14.intel.com ([192.55.52.115]:56070 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755731AbaIOVCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 17:02:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="386460491"
Message-ID: <541753A3.8010102@linux.intel.com>
Date: Mon, 15 Sep 2014 14:01:23 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Darren Hart <dvhart@infradead.org>
CC: Azael Avalos <coproscefalo@gmail.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH v2 3/5] toshiba_acpi: Fix accelerometer direction reporting
References: <1410569437-3066-1-git-send-email-coproscefalo@gmail.com> <1410569437-3066-2-git-send-email-coproscefalo@gmail.com> <20140915192923.GA61529@vmdeb7> <20140915195617.GA3652@kroah.com>
In-Reply-To: <20140915195617.GA3652@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/2014 12:56 PM, Greg Kroah-Hartman wrote:
> 
>> I have also suggested this device (2 actually) would be better supported as an
>> IIO accelerometer device, but even that would change the sysfs interface by
>> removing these altogether and using the IIO standardized path and accelerometer
>> interface.
> 
> That's a better goal overall, then the "odd" sysfs files are now gone,
> to be replaced with the standard interface which all tools should
> already be using.
> 

I would definitely agree with that, although I understood there were
technical concerns with that?

	-hpa


