Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965AbaJ1Cxn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 22:53:43 -0400
Received: from mail-yk0-f173.google.com ([209.85.160.173]:43391 "EHLO
	mail-yk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585AbaJ1Cxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 22:53:41 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.11.1410231246500.6969@knanqh.ubzr>
References: <1414054881-17713-1-git-send-email-daniel.lezcano@linaro.org>
	<1414054881-17713-5-git-send-email-daniel.lezcano@linaro.org>
	<alpine.LFD.2.11.1410231246500.6969@knanqh.ubzr>
Date: Mon, 27 Oct 2014 22:53:40 -0400
X-Google-Sender-Auth: gSXMt-jcCEnVXNQoJcXkFDWNhsk
Message-ID: <CAJvTdKnR1jmD2r0w0A1M=xfWov4uPOxuX+QMGG4oTU8GaG15-A@mail.gmail.com>
Subject: Re: [PATCH V2 5/5] cpuidle: menu: Move the update function before its declaration
From: Len Brown <lenb@kernel.org>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, linaro-kernel@lists.linaro.org,
        Patch Tracking <patches@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> This patch does not change the behavior of the governor, it is just code
>> reordering.
>>
>> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>


Acked-by: Len Brown <len.brown@intel.com>
