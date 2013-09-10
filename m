Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751374Ab3IJJ6j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 05:58:39 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:60306 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938Ab3IJJ6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 05:58:37 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.34 with qID r8A9wIi5013052, This message is accepted by code: ctloc85258
Message-ID: <522EED3A.9080806@realsil.com.cn>
Date: Tue, 10 Sep 2013 17:58:18 +0800
From: wwang <wei_wang@realsil.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: <sameo@linux.intel.com>, <devel@linuxdriverproject.org>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <rogerable@realtek.com>, <micky_ching@realsil.com.cn>
Subject: Re: [PATCH v3] mfd: rtsx: Modify rts5249_optimize_phy
References: <1378804397-28640-1-git-send-email-wei_wang@realsil.com.cn> <20130910092857.GB1456@lee--X1>
In-Reply-To: <20130910092857.GB1456@lee--X1>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.29.41.8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年09月10日 17:28, Lee Jones 写道:
> I would like some more information in the commit log though. You're
> making a lot of configuration changes here and due to the
> incomprehensible 'magic numbers' used previously, it's impossible to
> know what you're changing by just reading the code.
>
> Why won't the rts**** be initialise properly and what exactly are you
> changing to rectify the situation?

Hi Lee:

It's a little difficult to describe it very clearly. To put it simply, 
the default setting of rts5249 is not good, and it will cause the signal 
quality very bad. So we have to change those values to achieve a better 
signal quality.

Do I need amend the commit and add the above description and resend it ?

BR,
Wei
