Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221AbaAVKjJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 05:39:09 -0500
Received: from ozlabs.org ([203.10.76.45]:37131 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754659AbaAVKjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 05:39:07 -0500
Date: Wed, 22 Jan 2014 21:39:05 +1100
From: Anton Blanchard <anton@samba.org>
To: Rob Landley <rob@landley.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org
Subject: Re: powerpc32 broken by ef1313deafb7
Message-ID: <20140122213905.484575e8@kryten>
In-Reply-To: <52DAC581.9080806@landley.net>
References: <1389572866.1176.19@driftwood>
	<1389575361.4672.115.camel@pasglop>
	<52DAC581.9080806@landley.net>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Rob,

> I replied to this with the correct config last week. Did you get it? 
> Here it is again. Just built against a fresh git pull and it's still 
> happening for me...

Your .config built fine with a couple of different toolchains I have
here. One of them was the 4.7.3 powerpc64 biarch build:

https://www.kernel.org/pub/tools/crosstool/

What toolchain are you using for your builds?

Anton
