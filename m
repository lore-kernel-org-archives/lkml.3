Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932280Ab3BYJzL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 04:55:11 -0500
Received: from smtp-out-129.synserver.de ([212.40.185.129]:1066 "EHLO
	smtp-out-124.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757188Ab3BYJzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 04:55:09 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 13594
Message-ID: <512B355D.1000107@metafoo.de>
Date: Mon, 25 Feb 2013 10:56:45 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Jonathan Cameron <jic23@kernel.org>
CC: Guenter Roeck <linux@roeck-us.net>,
        Jonathan Cameron <jic23@jic23.retrosnub.co.uk>,
        linux-iio@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Doug Anderson <dianders@chromium.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, Anton Vorontsov <cbou@mail.ru>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH v5] iio: Add OF support
References: <1360256940-19438-1-git-send-email-linux@roeck-us.net> <5114B7B8.2080607@jic23.retrosnub.co.uk> <20130220165359.GA3424@roeck-us.net> <6d3189b1-69ee-4db2-9dcc-2a6c59ca6dc7@email.android.com>
In-Reply-To: <6d3189b1-69ee-4db2-9dcc-2a6c59ca6dc7@email.android.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2013 06:17 PM, Jonathan Cameron wrote:
> 
> 
> Guenter Roeck <linux@roeck-us.net> wrote:
> 
>> On Fri, Feb 08, 2013 at 08:30:48AM +0000, Jonathan Cameron wrote:
>>> On 07/02/13 17:09, Guenter Roeck wrote:
>>>> Provide bindings and parse OF data during initialization.
>>>>
>>>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>>> Looks fine to me.  Will give it a few more days to see what others
>>> have to say.
>>>
>> Hi Jonathan,
>>
>> Any further feedback on this ? If there is anything else I need to do
>> to get it accepted, please let me know.
> Was kind of hoping for a few ack/ reviewed by comments! Missed current merge window so I will pick it up for start of next cycle and assume silence means everyone else is happy!

The latest version looked good to me, you can add my:
Reviewed-by: Lars-Peter Clausen <lars@metafoo.de>
