Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480AbaKKDvA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 22:51:00 -0500
Received: from mail-qa0-f42.google.com ([209.85.216.42]:40319 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbaKKDu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 22:50:59 -0500
MIME-Version: 1.0
In-Reply-To: <20141110152645.GF20766@saruman>
References: <1415095254-24683-1-git-send-email-kiran.kumar@linaro.org>
	<20141110152645.GF20766@saruman>
Date: Tue, 11 Nov 2014 09:20:58 +0530
Message-ID: <CA+RfmHay7J5_ybchfRx5RaR1doQ6Y45fAMoDpwNdSwXYZCUrhA@mail.gmail.com>
Subject: Re: [RFC v5] usb: phy: Hold wakeupsource when USB is enumerated in
 peripheral mode
From: Kiran Raparthy <kiran.kumar@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Todd Poynor <toddpoynor@google.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        =?UTF-8?B?QXJ2ZSBIau+/vW5uZXbvv71n?= <arve@android.com>,
        Benoit Goby <benoit@android.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On 10 November 2014 20:56, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Tue, Nov 04, 2014 at 03:30:54PM +0530, Kiran Kumar Raparthy wrote:
>> @@ -1469,6 +1484,7 @@ static int ab8500_usb_probe(struct platform_device *pdev)
>>
>>       abx500_usb_link_status_update(ab);
>>
>> +     usb_phy_wsource_init(&ab->phy);
>
> instead of adding this to all drivers, you can just it to
> usb_add_phy_dev() and conversely, to usb_remove_phy().
Definitely,Thanks for your input.
Regards,
Kiran
>
> --
> balbi
