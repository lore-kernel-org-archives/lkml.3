Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512AbaFQGMO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 02:12:14 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:48937 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbaFQGMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 02:12:12 -0400
Message-ID: <539FDC3A.5080009@gmail.com>
Date: Tue, 17 Jun 2014 08:12:10 +0200
From: Andreas Tscharner <sternenfeuer@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.18) Gecko/20081105 Lightning/0.9 Thunderbird/2.0.0.18 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Ben Skeggs <skeggsb@gmail.com>, Ben Skeggs <bskeggs@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        nouveau <nouveau@lists.freedesktop.org>, damien.wyart@gmail.com
Subject: Re: [Nouveau] REGRESSION: Kernel PANIC 8777c5c11764d8336d8270f96778158c34c92108
 - drm/nouveau/dp: probe dpcd to determine connectedness
References: <20140613095820.GA21162@glanzmann.de>	<CACAvsv5dVMKcF67SO1qT=Foh4F0DkHeWNUztf8sQf++8GF-eMw@mail.gmail.com>	<20140617053332.GA9117@glanzmann.de> <CACAvsv6nyu4cw6Yc1r5L8XNbS_Dyrka7o1JH=2Kc6URUWVcxjA@mail.gmail.com>
In-Reply-To: <CACAvsv6nyu4cw6Yc1r5L8XNbS_Dyrka7o1JH=2Kc6URUWVcxjA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.06.2014 07:39, Ben Skeggs wrote:

[snip]
> In any case, I encountered the oops myself earlier (absolutely nothing
> to do with that commit) and fixed it here.  I've sent it onto Dave for
> the next -fixes merge, so hopefully it'll help your case too.

Has this anything to do with

<CADJQGJe=CmRn0PmofRUFwZEF-Ah=NAnZVpL1uKYTDLd3Oz_OEQ@mail.gmail.com>
"Machine freeze on latest Linus kernel, seems related to nouveau" from 
Damien Wyart

?

TIA and best regards
	Andreas
-- 
Andreas Tscharner                             <sternenfeuer@gmail.com>
----------------------------------------------------------------------
"Intruder on level one. All Aliens please proceed to level one."
                                       -- Call in "Alien: Resurrection"
