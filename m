Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386Ab3KFVfo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 16:35:44 -0500
Received: from mail-ve0-f174.google.com ([209.85.128.174]:57392 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245Ab3KFVfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 16:35:42 -0500
MIME-Version: 1.0
In-Reply-To: <20131106085127.GB22856@console-pimps.org>
References: <52715D9E.10701@hds.com>
	<20131106085127.GB22856@console-pimps.org>
Date: Wed, 6 Nov 2013 13:35:41 -0800
Message-ID: <CA+8MBb+G3rc711u4ZmpYQTUGXyeBUGi-K_YBWenDyGjXJYa0qA@mail.gmail.com>
Subject: Re: [PATCH v4] efivars,efi-pstore: Hold off deletion of sysfs entry
 until the scan is completed
From: Tony Luck <tony.luck@gmail.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Matt Fleming <matt.fleming@intel.com>, tomoki.sekiyama@hds.com,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Madper Xie <cxie@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 6, 2013 at 12:51 AM, Matt Fleming <matt@console-pimps.org> wrote:
> Tony, want me to pick this up since it touches various EFI bits?

Since there are now no generic pstore changes - it is all in the efi
backend ... yes,
it makes sense for you to take this.

Thanks

[And thanks to Madper Xie for patiently coding through all these variations]

-Tony
