Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab3HCCO6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 22:14:58 -0400
Received: from mail-qe0-f52.google.com ([209.85.128.52]:47343 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785Ab3HCCO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 22:14:57 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <20130803004838.GU23006@n2100.arm.linux.org.uk>
References: <CAOesGMgWeP-CdmOE-S7XZmJ-+1buP9a1cqavUns2gpgKrrhaxQ@mail.gmail.com>
	<20130803000731.GS23006@n2100.arm.linux.org.uk>
	<CAOesGMi3FBz7-tQSxgQMgHiHmPTnO4k57MkhQTQTvtB0Q6WyNw@mail.gmail.com>
	<20130803004111.GT23006@n2100.arm.linux.org.uk>
	<20130803004838.GU23006@n2100.arm.linux.org.uk>
Date: Fri, 2 Aug 2013 19:14:56 -0700
Message-ID: <CAOesGMjCKD+1E_LTPbaEiLBC054nPcnXevXUtt5+OOYBqW6e-Q@mail.gmail.com>
Subject: Re: Build breakage due to latest ARM fixes
From: Olof Johansson <olof@lixom.net>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 2, 2013 at 5:48 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:

> Okay, this should fix it - *untested* though because of the fscking time
> it is here again.  The problem is that install_special_mapping() assumes
> that the pointer to the pages will be persistent, and it wasn't.  I found
> that during testing and thought I'd merged the patches in, but I seem to
> have totally destroyed the original fixes for this.

Ran it through my autobuilder/booter here, didn't fall over like without it.

Tested-by: Olof Johansson <olof@lixom.net>


-Olof
