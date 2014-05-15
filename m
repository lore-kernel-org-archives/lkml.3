Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107AbaEOIrA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 04:47:00 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:43126 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbaEOIq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 04:46:56 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpo=O_=PVpFCnTWA=0R6deMFHgWx8dxOecro1dMwGVwxong@mail.gmail.com>
References: <1399966890-22926-1-git-send-email-k.chander@samsung.com>
	<CAGo_u6qTZ-yq26+K5nHut92d=-9nrCHKDNK9EMLK5kGMQc+dOw@mail.gmail.com>
	<CANuQgHGehqDD8-SKTfEKMEZmT5KwofFL8bhYqge0uNm6kpPgUQ@mail.gmail.com>
	<CAKohponfdoPG7H4h-5s+V7CwB_SgnyqqUm9aa6G-K_cX3DOcfA@mail.gmail.com>
	<53737D34.5040307@ti.com>
	<CANuQgHG23F7zGxbNJVzGAeCsNNPU_CwSu5veK2-CCjnc1RE-UQ@mail.gmail.com>
	<CAKohpo=O_=PVpFCnTWA=0R6deMFHgWx8dxOecro1dMwGVwxong@mail.gmail.com>
Date: Thu, 15 May 2014 14:16:56 +0530
Message-ID: <CANuQgHEECW3c2C5+h7vUp5RuWJin3PPaos_BY1VoqzR=jTwGFQ@mail.gmail.com>
Subject: Re: [PATCH] PM / OPP: discard duplicate OPP additions
From: Chander Kashyap <chander.kashyap@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Nishanth Menon <nm@ti.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chander Kashyap <k.chander@samsung.com>,
        Inderpal Singh <inderpal.s@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 May 2014 13:57, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 15 May 2014 13:55, Chander Kashyap <chander.kashyap@linaro.org> wrote:
>> Then in that case the caller must take care for two type of errors:
>> -EEXIST and -ENOMEM
>
> Actually, success: (0 or -EEXIST), failure: Anything else.

Yes exactly. All users of this API need to be modified to handle
EEXIST as success.

To avoid this returning 0 was suggested,

-- 
with warm regards,
Chander Kashyap
