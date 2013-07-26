Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760476Ab3GZXyK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 19:54:10 -0400
Received: from forward9.mail.yandex.net ([77.88.61.48]:44999 "EHLO
	forward9.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756125Ab3GZXyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 19:54:08 -0400
From: =?koi8-r?B?8tXT1MHGwSDk1sHN1dLByM3F1M/X?= <zbr@ioremap.net>
Envelope-From: drustafa@yandex.ru
To: GregKH <greg@kroah.com>
Cc: Jingoo Han <jg1.han@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20130726231621.GB30720@kroah.com>
References: <001401ce844f$d4047db0$7c0d7910$@samsung.com>
 <1435421374523244@web23e.yandex.ru> <20130726231621.GB30720@kroah.com>
Subject: Re: [PATCH] w1: replace strict_strtol() with kstrtol()
MIME-Version: 1.0
Message-Id: <576671374882843@web12e.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Sat, 27 Jul 2013 03:54:03 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



27.07.2013, 03:16, "GregKH" <greg@kroah.com>:
> On Tue, Jul 23, 2013 at 12:00:44AM +0400, Evgeniy Polyakov wrote:
>
>> šHi everyone
>>
>> š19.07.2013, 11:16, "Jingoo Han" <jg1.han@samsung.com>:
>>> šThe usage of strict_strtol() is not preferred, because
>>> šstrict_strtol() is obsolete. Thus, kstrtol() should be
>>> šused.
>> šLooks good to me, although I do not really see the difference
>> šGreg, please pull into your tree or suggest appropriate.
>>
>> šAcked-by: Evgeniy Polyakov <zbr@ioremap.net>
>
> Can someone resend this, I don't seem to be able to find it...

Looks like Andrew Morton picked it up today
