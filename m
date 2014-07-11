Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452AbaGKPYS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 11:24:18 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:41025 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871AbaGKPYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 11:24:13 -0400
MIME-Version: 1.0
In-Reply-To: <20140711093450.GA26660@verge.net.au>
References: <CAPDOMViqzoX_VAJKFB34LXLBVUBTbs4hWq-K_8+bC-m2NmahCQ@mail.gmail.com>
	<20140711093450.GA26660@verge.net.au>
Date: Fri, 11 Jul 2014 11:24:12 -0400
Message-ID: <CAPDOMVgi-GMQp101eZewVBOK_nFD8UJ04UydQ6bxa6Y5FP_VgQ@mail.gmail.com>
Subject: Re: mach-shmobile: FIXME message in file pm-sh732.c
From: Nick Krause <xerofoify@gmail.com>
To: Simon Horman <horms@verge.net.au>
Cc: Magnus Damm <magnus.damm@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 5:34 AM, Simon Horman <horms@verge.net.au> wrote:
> On Fri, Jul 04, 2014 at 12:34:58AM -0400, Nick Krause wrote:
>> While searching for FIX ME messages when using cscope on the latest kernels I
>> get a message on 68 of this file and was wondering what I need to define SMFRAM
>> as in order for it to point to things needed to support this portion
>> of the  hardware.
>
> Hi Nick,
>
> while I don't have a technical answer to your question I do believe
> that the code in question will be removed in the not too distant future
> along with support for the sh7372 SoC.

Why are we removing support for this SoC? Is there any reason?
Nick
