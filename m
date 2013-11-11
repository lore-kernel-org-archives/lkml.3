Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab3KKP2A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 10:28:00 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:40647 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753786Ab3KKP1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 10:27:52 -0500
Date: Mon, 11 Nov 2013 15:27:46 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Tony Luck <tony.luck@gmail.com>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Matt Fleming <matt.fleming@intel.com>, tomoki.sekiyama@hds.com,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Madper Xie <cxie@redhat.com>
Subject: Re: [PATCH v4] efivars,efi-pstore: Hold off deletion of sysfs entry
 until the scan is completed
Message-ID: <20131111152746.GG22636@console-pimps.org>
References: <52715D9E.10701@hds.com>
 <20131106085127.GB22856@console-pimps.org>
 <CA+8MBb+G3rc711u4ZmpYQTUGXyeBUGi-K_YBWenDyGjXJYa0qA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+8MBb+G3rc711u4ZmpYQTUGXyeBUGi-K_YBWenDyGjXJYa0qA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Nov, at 01:35:41PM, Tony Luck wrote:
> On Wed, Nov 6, 2013 at 12:51 AM, Matt Fleming <matt@console-pimps.org> wrote:
> > Tony, want me to pick this up since it touches various EFI bits?
> 
> Since there are now no generic pstore changes - it is all in the efi
> backend ... yes,
> it makes sense for you to take this.

Applied, thanks everyone.

-- 
Matt Fleming, Intel Open Source Technology Center
