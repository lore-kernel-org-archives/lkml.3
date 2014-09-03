Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871AbaICAcF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 20:32:05 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:56566 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755855AbaICAcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 20:32:03 -0400
MIME-Version: 1.0
In-Reply-To: <20140829205015.GE16391@saruman.home>
References: <1408700972-8518-1-git-send-email-kiran.kumar@linaro.org>
	<20140822171210.GD27616@saruman.home>
	<CAAW3YpZPOCkTkx=OM_0ZYA7brh5t32miprstLqGyurD9vN94yg@mail.gmail.com>
	<20140829205015.GE16391@saruman.home>
Date: Tue, 2 Sep 2014 17:32:01 -0700
Message-ID: <CAAW3YpYBwPRa7E5iGDaUGi2gu5DHHE5F3hDexXns_Hd98mj-yg@mail.gmail.com>
Subject: Re: [RFC 1/2] USB: OTG: Hold wakeupsource when VBUS present
From: Todd Poynor <toddpoynor@google.com>
To: balbi@ti.com
Cc: Kiran Kumar Raparthy <kiran.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        =?UTF-8?B?QXJ2ZSBIau+/vW5uZXbvv71n?= <arve@android.com>,
        Benoit Goby <benoit@android.com>,
        Ruchi Kandoi <kandoiruchi@google.com>,
        Badhri Jagan Sridharan <badhri@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2014 at 1:50 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Wed, Aug 27, 2014 at 02:58:30PM -0700, Todd Poynor wrote:
>> On Fri, Aug 22, 2014 at 10:12 AM, Felipe Balbi <balbi@ti.com> wrote:
>> ...
>> > you never explain why this is needed and you have also added some
>> > information to commit log which shouldn't be here.
>>
>> Android uses this to prevent suspend from interfering with USB
>> peripheral traffic, notably adb.
>
> aaaaah, that's because Android freezes userspace right ?

Yes, and only wakeup interrupts will be enabled; it is a suspend-to-RAM.


Todd
