Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910AbaEOI1k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 04:27:40 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:60707 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752870AbaEOI1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 04:27:36 -0400
MIME-Version: 1.0
In-Reply-To: <CANuQgHG23F7zGxbNJVzGAeCsNNPU_CwSu5veK2-CCjnc1RE-UQ@mail.gmail.com>
References: <1399966890-22926-1-git-send-email-k.chander@samsung.com>
	<CAGo_u6qTZ-yq26+K5nHut92d=-9nrCHKDNK9EMLK5kGMQc+dOw@mail.gmail.com>
	<CANuQgHGehqDD8-SKTfEKMEZmT5KwofFL8bhYqge0uNm6kpPgUQ@mail.gmail.com>
	<CAKohponfdoPG7H4h-5s+V7CwB_SgnyqqUm9aa6G-K_cX3DOcfA@mail.gmail.com>
	<53737D34.5040307@ti.com>
	<CANuQgHG23F7zGxbNJVzGAeCsNNPU_CwSu5veK2-CCjnc1RE-UQ@mail.gmail.com>
Date: Thu, 15 May 2014 13:57:36 +0530
Message-ID: <CAKohpo=O_=PVpFCnTWA=0R6deMFHgWx8dxOecro1dMwGVwxong@mail.gmail.com>
Subject: Re: [PATCH] PM / OPP: discard duplicate OPP additions
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Chander Kashyap <chander.kashyap@linaro.org>
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

On 15 May 2014 13:55, Chander Kashyap <chander.kashyap@linaro.org> wrote:
> Then in that case the caller must take care for two type of errors:
> -EEXIST and -ENOMEM

Actually, success: (0 or -EEXIST), failure: Anything else.
