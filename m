Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659AbaEGQsa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 12:48:30 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45456 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165AbaEGQs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 12:48:29 -0400
Date: Wed, 7 May 2014 17:48:01 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: "David E. Box" <david.e.box@linux.intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        rafael.j.wysocki@intel.com, linux-kernel@vger.kernel.org,
        kristen.c.accardi@intel.com, jacob.jun.pan@linux.intel.com
Subject: Re: [PATCH v3] x86/iosf: Make IOSF driver modular and usable by
 more drivers
Message-ID: <20140507174801.20fc0d67@alan.etchedpixels.co.uk>
In-Reply-To: <1399052199-8703-1-git-send-email-david.e.box@linux.intel.com>
References: <1398810789-2301-1-git-send-email-david.e.box@linux.intel.com>
	<1399052199-8703-1-git-send-email-david.e.box@linux.intel.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  2 May 2014 10:36:39 -0700
> +bool iosf_mbi_available(void)
> +{
> +	return mbi_pdev;
> +}
> +EXPORT_SYMBOL(iosf_mbi_available);

Probably worth a follow up patch that comments this so the assumption
that iosf can never be unloaded or hot-unplugged is clear.

Alan
