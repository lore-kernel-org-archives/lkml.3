Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910AbaKZAMF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 19:12:05 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409AbaKZAMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 19:12:03 -0500
Message-ID: <54751ACF.9050604@nod.at>
Date: Wed, 26 Nov 2014 01:11:59 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, gregkh@linuxfoundation.org,
        rafael.j.wysocki@intel.com, pebolle@tiscali.nl,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: defconfig: Enable CONFIG_FHANDLE
References: <1416958612-7448-1-git-send-email-richard@nod.at> <20141125234326.GA10021@redhat.com>
In-Reply-To: <20141125234326.GA10021@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 26.11.2014 um 00:43 schrieb Dave Jones:
> On Wed, Nov 26, 2014 at 12:36:52AM +0100, Richard Weinberger wrote:
>  > systemd has a hard dependency on CONFIG_FHANDLE.
>  > If you run systemd with CONFIG_FHANDLE=n it will somehow
>  > boot but fail to spawn a getty or other basic services.
>  > As systemd is now used by most x86 distributions it
>  > makes sense to enabled this by default and save kernel
>  > hackers a lot of value debugging time.
> 
> Perhaps also note this in the kconfig entry for it ?

I'm not sure if this helps a lot.
But I can create patch (including for all other systemd dependencies).

Thanks,
//richard
