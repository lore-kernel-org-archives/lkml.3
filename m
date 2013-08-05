Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651Ab3HETKB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 15:10:01 -0400
Received: from tex.lwn.net ([70.33.254.29]:39256 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754595Ab3HETKA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 15:10:00 -0400
Date: Mon, 5 Aug 2013 13:09:58 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: [RFC v01 1/3] PowerCap: Documentation
Message-ID: <20130805130958.33da86c3@lwn.net>
In-Reply-To: <1375466932-11842-2-git-send-email-srinivas.pandruvada@linux.intel.com>
References: <1375466932-11842-1-git-send-email-srinivas.pandruvada@linux.intel.com>
	<1375466932-11842-2-git-send-email-srinivas.pandruvada@linux.intel.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  2 Aug 2013 11:08:50 -0700
Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com> wrote:

> +power_uw (rw): Current power counter in micro-watts. Write to this counter
> +resets the counter to zero. If the counter can not be reset, then this attribute
> +is read-only.

Sorry if I'm slow, but... power is an instantaneous quantity, so why would
you use a counter for it?  And why would you want to reset it to zero?

Thanks,

jon
