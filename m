Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293AbaIHKpT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 06:45:19 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:62563 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974AbaIHKpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 06:45:18 -0400
Message-ID: <540D88B5.7020702@cogentembedded.com>
Date: Mon, 08 Sep 2014 14:45:09 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Kiran Kumar Raparthy <kiran.kumar@linaro.org>,
        linux-kernel@vger.kernel.org
CC: Todd Poynor <toddpoynor@google.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [RFC v3 2/2] usb: phy: Temporarily hold timed wakeup source on
 charger and disconnect events
References: <1410171049-14239-1-git-send-email-kiran.kumar@linaro.org>
In-Reply-To: <1410171049-14239-1-git-send-email-kiran.kumar@linaro.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 9/8/2014 2:10 PM, Kiran Kumar Raparthy wrote:

> From: Todd Poynor <toddpoynor@google.com>

> usb: phy: Temporarily hold timed wakeup source on charger and disconnect
> events

    No need to duplicate the summary.

> It temporarily holds a timed wakeup source on USB disconnect events, to allow

    What "it"?

> the rest of the system time to react to the USB disconnection (dropping host
> sessions, updating charger status, etc.) prior to re-allowing suspend

> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-usb@vger.kernel.org
> Cc: Android Kernel Team <kernel-team@android.com>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Sumit Semwal <sumit.semwal@linaro.org>
> Signed-off-by: Todd Poynor <toddpoynor@google.com>
> [kiran: Added context to commit message and
> addressed community feedback]
> Signed-off-by: Kiran Raparthy <kiran.kumar@linaro.org>

WBR, Sergei

