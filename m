Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288AbaIHQPl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 12:15:41 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:40961 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788AbaIHQPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 12:15:38 -0400
Message-ID: <540DD627.5080900@cogentembedded.com>
Date: Mon, 08 Sep 2014 20:15:35 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Kiran Raparthy <kiran.kumar@linaro.org>
CC: LKML <linux-kernel@vger.kernel.org>, Todd Poynor <toddpoynor@google.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [RFC v3 2/2] usb: phy: Temporarily hold timed wakeup source on
 charger and disconnect events
References: <1410171049-14239-1-git-send-email-kiran.kumar@linaro.org>	<540D88B5.7020702@cogentembedded.com> <CA+RfmHbaf=FBD8jYbigoUKB=BE8pmRwjp2RFM9xoU4-dq9=3UA@mail.gmail.com>
In-Reply-To: <CA+RfmHbaf=FBD8jYbigoUKB=BE8pmRwjp2RFM9xoU4-dq9=3UA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 9/8/2014 2:55 PM, Kiran Raparthy wrote:

>>>         From: Todd Poynor <toddpoynor@google.com <mailto:toddpoynor@google.com>>

>>>         usb: phy: Temporarily hold timed wakeup source on charger and disconnect
>>>         events

>>         No need to duplicate the summary.

>>>         It temporarily holds a timed wakeup source on USB disconnect events,
>>>         to allow

>>         What "it"?

> I was referring to "This patch" ,if required,i can change the terminology.
> Regards,
> Kiran

    Yes, please. Just write "Temporarily hold ...", no need for a noun.
And please don't send HTML mails to the mailing list (it should bounce them 
anyway).

WBR, Sergei

