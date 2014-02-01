Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933444AbaBASXx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 13:23:53 -0500
Received: from mail-vb0-f42.google.com ([209.85.212.42]:64844 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933256AbaBASXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 13:23:51 -0500
MIME-Version: 1.0
In-Reply-To: <14676899.LOmsodapl3@vostro.rjw.lan>
References: <20140130131236.GW18029@intel.com>
	<1676758.QjUXk2223P@vostro.rjw.lan>
	<CAE9FiQX_AuSPq159AwDHP+n0k6FK3pS2CNttPFAJP2K-84ho1w@mail.gmail.com>
	<14676899.LOmsodapl3@vostro.rjw.lan>
Date: Sat, 1 Feb 2014 10:23:51 -0800
X-Google-Sender-Auth: y_szoNdlcf-8Vf7CVN-fLfsnWHw
Message-ID: <CA+55aFyG+nFz-CZmaci7-uinnK8a5QhyJ5Yq+Q+tSA8oR3nW5g@mail.gmail.com>
Subject: Re: [PATCH] Revert "PCI: Remove from bus_list and release resources
 in pci_release_dev()"
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 1, 2014 at 6:38 AM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
>
> Updated revert follows.

I'm taking this directly, since I'll cut rc1 tomorrow (or maybe later today).

           Linus
