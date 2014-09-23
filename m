Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbaIWH4Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 03:56:16 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.219]:48841 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbaIWH4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 03:56:15 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWi/zfN1cLnBYfstVolSR8Cl8fNabDQrlSrQo8jPq2gOVbkBPuE3yQ==
X-RZG-CLASS-ID: mo00
Date: Tue, 23 Sep 2014 09:56:10 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Thomas Shao <huishao@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, apw@canonical.com,
        jasowang@redhat.com, kys@microsoft.com, haiyangz@microsoft.com
Subject: Re: [PATCH] Drivers: hv: util: Implement Time Synchronization using
 host time sample
Message-ID: <20140923075610.GA10933@aepfle.de>
References: <1411451081-13423-1-git-send-email-huishao@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1411451081-13423-1-git-send-email-huishao@microsoft.com>
User-Agent: Mutt/1.5.22.rev6346 (2013-10-29)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, Thomas Shao wrote:

> In current hyper-v time sync service,it only gets the initial clock time
> from the host. It didn't process the following time samples. This change
> introduced a module parameter called host_time_sync. If it is set to true,
> the guest will periodically sychronize it's time with the host clock using
> host time sample. By default it is disabled, because we still recommend
> user to configure NTP for time synchronization.

Is that new knob a temporary thing to aid testing and development?
Because once it sneaks in it becomes some sort of ABIT.
So if the outcome of all that is that 'sync with host every once in a
while' will be the default, the new knob is not required.

Olaf
