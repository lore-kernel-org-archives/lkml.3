Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758268Ab3BVUnw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 15:43:52 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:43077 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758178Ab3BVUnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 15:43:51 -0500
Message-ID: <5127D884.6020701@linaro.org>
Date: Fri, 22 Feb 2013 12:43:48 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Prarit Bhargava <prarit@redhat.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, Matt Fleming <matt.fleming@intel.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, linux-efi@vger.kernel.org
Subject: Re: [RFE PATCH 2/2] rtc, add write functionality to sysfs
References: <1360861375-24131-1-git-send-email-prarit@redhat.com> <1360861375-24131-3-git-send-email-prarit@redhat.com>
In-Reply-To: <1360861375-24131-3-git-send-email-prarit@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2013 09:02 AM, Prarit Bhargava wrote:
> /sys/class/rtc/rtcX/date and /sys/class/rtc/rtcX/time currently have
> read-only access.  This patch introduces write functionality which will
> set the rtc time.
>
> Usage: echo YYYY-MM-DD > /sys/class/rtc/rtcX/date
>         echo HH:MM:SS > /sys/class/rtc/rtcX/time

Why do we want to add a new interface here?

thanks
-john

