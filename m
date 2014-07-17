Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988AbaGQHwZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 03:52:25 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:32946 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452AbaGQHwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 03:52:22 -0400
Date: Thu, 17 Jul 2014 09:52:04 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Nick Krause <xerofoify@gmail.com>
Cc: David Miller <davem@davemloft.net>, sparclinux@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Sparc: Fix Mes in highmem.c
Message-ID: <20140717075204.GA15569@ravnborg.org>
References: <CAPDOMVjTxTNTfgPJMz6eNfabXuvtJ43YMpEeDEQ236EtF168Cg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPDOMVjTxTNTfgPJMz6eNfabXuvtJ43YMpEeDEQ236EtF168Cg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 10:25:30PM -0400, Nick Krause wrote:
> I am hitting three Fix mes in this file and am wondering as the
> maintainer how you would like
> to clean them up.

They may be addressed if we one day decide to give the sparc32 highmem
support a big overhaul. Until then they are left as is.

	Sam
