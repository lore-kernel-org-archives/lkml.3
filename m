Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750754Ab3HSNjz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 09:39:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11175 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707Ab3HSNjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 09:39:54 -0400
Message-ID: <52122026.2010700@redhat.com>
Date: Mon, 19 Aug 2013 15:39:50 +0200
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Mika Westerberg <mika.westerberg@linux.intel.com>
CC: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH] HID: i2c-hid: use correct type for ACPI _DSM parameter
References: <1376910077-24433-1-git-send-email-mika.westerberg@linux.intel.com>
In-Reply-To: <1376910077-24433-1-git-send-email-mika.westerberg@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/08/13 13:01, Mika Westerberg wrote:
> ACPI 5.0 specification requires the fourth parameter to the _DSM (Device
> Specific Method) to be of type package instead of integer. Failing to do
> that we get following warning on the console:
> 
>   ACPI Warning: \_SB_.PCI0.I2C1.TPL0._DSM: Argument #4 type mismatch - Found [Integer],
>                 ACPI requires [Package] (20130517/nsarguments-95)
> 
> Fix this by passing an empty package to the _DSM method. The HID over I2C
> specification doesn't require any specific values to be passed with this
> parameter.
> 
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> ---

Looks simple and straightforward :)

Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Cheers,
Benjamin
