Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916AbaGKOSU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 10:18:20 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:35735 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbaGKOSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 10:18:17 -0400
Date: Fri, 11 Jul 2014 11:34:51 +0200
From: Simon Horman <horms@verge.net.au>
To: Nick Krause <xerofoify@gmail.com>
Cc: magnus.damm@gmail.com, Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: mach-shmobile: FIXME message in file pm-sh732.c
Message-ID: <20140711093450.GA26660@verge.net.au>
References: <CAPDOMViqzoX_VAJKFB34LXLBVUBTbs4hWq-K_8+bC-m2NmahCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPDOMViqzoX_VAJKFB34LXLBVUBTbs4hWq-K_8+bC-m2NmahCQ@mail.gmail.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04, 2014 at 12:34:58AM -0400, Nick Krause wrote:
> While searching for FIX ME messages when using cscope on the latest kernels I
> get a message on 68 of this file and was wondering what I need to define SMFRAM
> as in order for it to point to things needed to support this portion
> of the  hardware.

Hi Nick,

while I don't have a technical answer to your question I do believe
that the code in question will be removed in the not too distant future
along with support for the sh7372 SoC.
