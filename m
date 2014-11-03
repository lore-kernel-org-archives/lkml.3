Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522AbaKCTp4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 14:45:56 -0500
Received: from www.linutronix.de ([62.245.132.108]:55166 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458AbaKCTpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 14:45:52 -0500
Date: Mon, 3 Nov 2014 20:45:42 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel J Blueman <daniel@numascale.com>
cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Bjorn Helgaas <bhelgaas@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Steffen Persvold <sp@numascale.com>
Subject: Re: [PATCH v3 3/5] Numachip: Add safe is-present function
In-Reply-To: <1414915813-2462-3-git-send-email-daniel@numascale.com>
Message-ID: <alpine.DEB.2.11.1411032044590.5308@nanos>
References: <1414915813-2462-1-git-send-email-daniel@numascale.com> <1414915813-2462-3-git-send-email-daniel@numascale.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Nov 2014, Daniel J Blueman wrote:

> Add safe function to check if Numachip is detected, to be used elsewhere.

I cannot find a use case for this. I guess this is a left over of the
earlier 2G change, right?
 
Thanks,

	tglx
