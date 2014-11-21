Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932361AbaKUPnD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 10:43:03 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:50345 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758418AbaKUPnC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 10:43:02 -0500
MIME-Version: 1.0
In-Reply-To: <20141121151105.GC7508@saruman>
References: <cover.1416547297.git.kiran.kumar@linaro.org>
	<7a23b5f0af4463aea85384b6a67678b9c41b9d2d.1416547297.git.kiran.kumar@linaro.org>
	<20141121151105.GC7508@saruman>
Date: Fri, 21 Nov 2014 21:13:00 +0530
Message-ID: <CA+RfmHZo4FuH6-Z8+VFY7Ao5QVD-VmfdCm17ZrB6f7J8Xpo-Aw@mail.gmail.com>
Subject: Re: [PATCH v1 2/3] usb: phy: Handle per-PHY event for connect and
 disconnect events
From: Kiran Raparthy <kiran.kumar@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org,
        Android Kernel Team <kernel-team@android.com>,
        =?UTF-8?B?QXJ2ZSBIau+/vW5uZXbvv71n?= <arve@android.com>,
        Benoit Goby <benoit@android.com>, Todd Poynor <toddpoynor@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 November 2014 20:41, Felipe Balbi <balbi@ti.com> wrote:
> On Fri, Nov 21, 2014 at 11:31:21AM +0530, Kiran Raparthy wrote:
>> usb: phy: Handle per-PHY event for connnect and disconnect events
>>
>> When usb is connected and enumerated in device mode or when usb is
>> disconnected,call usb_phy_set_event from phy drivers to handle per-PHY event.
>>
>> Cc: Felipe Balbi <balbi@ti.com>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: linux-kernel@vger.kernel.org
>> Cc: linux-usb@vger.kernel.org
>> Cc: Android Kernel Team <kernel-team@android.com>
>> Cc: John Stultz <john.stultz@linaro.org>
>> Cc: Sumit Semwal <sumit.semwal@linaro.org>
>> Cc: Arve Hj�nnev�g <arve@android.com>
>> Cc: Benoit Goby <benoit@android.com>
>> [Original patch in Android from Todd]
>> Cc: Todd Poynor <toddpoynor@google.com>
>> Signed-off-by: Kiran Raparthy <kiran.kumar@linaro.org>
>
> this patch doesn't apply, please rebase entire series on my testing/next.
Sure,
Regards,
Kiran
>
> --
> balbi
