Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759494AbaCTR1U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 13:27:20 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:59154 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759397AbaCTR0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 13:26:19 -0400
MIME-Version: 1.0
In-Reply-To: <532A5A62.5020303@gmail.com>
References: <1394016605-24120-1-git-send-email-sebastian.capella@linaro.org>
	<1394016605-24120-3-git-send-email-sebastian.capella@linaro.org>
	<20140316070917.GA3094@arch.cereza>
	<CADHgK6s58EJyJxB-47K8w26H8ZCBFQ2zu7PGAQU9O+2g7=fPwA@mail.gmail.com>
	<20140317204410.GA1118@arch.cereza>
	<CADHgK6tHngKVZS=jo=VYt3Nt3dhiEmiWr28iDy7q_uR9goBj=Q@mail.gmail.com>
	<20140319154434.GA3488@arch.cereza>
	<532A5A62.5020303@gmail.com>
Date: Thu, 20 Mar 2014 10:26:17 -0700
Message-ID: <CADHgK6uDEb88P-r_7CnYAOBxkNF9yd7ir6WqEPFZrbGdc1tHOQ@mail.gmail.com>
Subject: Re: [PATCH v7 2/2] ARM hibernation / suspend-to-disk
From: Sebastian Capella <sebastian.capella@linaro.org>
To: TonyHo <tonyho.profession@gmail.com>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Victor Kamensky <victor.kamensky@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Jiang Liu <liuj97@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

I have not used the tux-on-ice solution.  The patchset I've sent is to
add initial support for swsusp based hibernation for ARM.

Can you please begin a new, separate thread for this?  Ie. separate
from the review for the swsusp hibernation patches I've submitted?
I'm not sure where the right list/forum is for this, perhaps someone
can make a recommendation, but I am not sure it should go on LKML.
Please copy me on your new thread.

Thanks!

Sebastian
