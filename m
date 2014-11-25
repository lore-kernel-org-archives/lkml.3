Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751654AbaKYXn6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 18:43:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54297 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869AbaKYXn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 18:43:57 -0500
Date: Tue, 25 Nov 2014 18:43:26 -0500
From: Dave Jones <davej@redhat.com>
To: Richard Weinberger <richard@nod.at>
Cc: x86@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        gregkh@linuxfoundation.org, rafael.j.wysocki@intel.com,
        pebolle@tiscali.nl, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: defconfig: Enable CONFIG_FHANDLE
Message-ID: <20141125234326.GA10021@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Richard Weinberger <richard@nod.at>, x86@kernel.org,
	tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
	gregkh@linuxfoundation.org, rafael.j.wysocki@intel.com,
	pebolle@tiscali.nl, linux-kernel@vger.kernel.org
References: <1416958612-7448-1-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416958612-7448-1-git-send-email-richard@nod.at>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 12:36:52AM +0100, Richard Weinberger wrote:
 > systemd has a hard dependency on CONFIG_FHANDLE.
 > If you run systemd with CONFIG_FHANDLE=n it will somehow
 > boot but fail to spawn a getty or other basic services.
 > As systemd is now used by most x86 distributions it
 > makes sense to enabled this by default and save kernel
 > hackers a lot of value debugging time.

Perhaps also note this in the kconfig entry for it ?

	Dave
