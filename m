Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982Ab3KSWIe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 17:08:34 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:39147 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812Ab3KSWIc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 17:08:32 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        "Jonghwan Choi" <jhbird.choi@gmail.com>
From: Sebastian Capella <sebastian.capella@linaro.org>
In-Reply-To: <27161890.Zx6CiZOMr8@amdc1032>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "MyungJoo Ham" <myungjoo.ham@samsung.com>,
        "Kukjin Kim" <kgene.kim@samsung.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        "Jonghwan Choi" <jhbird.choi@samsung.com>
References: <1384867831-15383-1-git-send-email-jhbird.choi@samsung.com>
 <27161890.Zx6CiZOMr8@amdc1032>
Message-ID: <20131119220829.27502.62997@capellas-linux>
User-Agent: alot/0.3.4
Subject: Re: [PATCH 4/4] PM / devfreq: Consider hibernation in pm notifier
Date: Tue, 19 Nov 2013 14:08:29 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Bartlomiej Zolnierkiewicz (2013-11-19 06:50:05)
> Hi,
> 
> Are you planning to add hibernation support to ARM?
> 
> If so then this should be stated somewhere in the patch description.
> 
> OTOH if you are not going to add hibernation support to ARM I see
> a little sense in adding hibernation support to ARM-only drivers..

FYI, we at Linaro and a few others have been working on adding
hibernation support for ARM.  I have not coordinated with Jonghwan
however.

Apoligies for the earlier toppost.

Thanks,

Sebastian Capella
