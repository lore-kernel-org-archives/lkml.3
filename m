Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758726AbaCSA4b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 20:56:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34294 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758712AbaCSA4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 20:56:30 -0400
Date: Tue, 18 Mar 2014 17:58:32 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: DaeSeok Youn <daeseok.youn@gmail.com>
Cc: devel <devel@driverdev.osuosl.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: unisys: use kzalloc instead of kmalloc/memset 0
Message-ID: <20140319005832.GB18725@kroah.com>
References: <4376102.svyTz8ADVT@daeseok-laptop.cloud.net>
 <20140317214145.GA29105@kroah.com>
 <CAHb8M2BwuCJEGueP+-cOatynS5QcSrJMeei_D=0-GdKGxi5N-Q@mail.gmail.com>
 <20140318003725.GA12217@kroah.com>
 <CAHb8M2D9Hf6pRza8-xgoSQrWx0x8CBv-qrThLWF3Hb6nZQQn7Q@mail.gmail.com>
 <CAHb8M2C0pBFuzA_Q+-zBkHT2ZckDKEkAvD0oiM900_ZhxxH2PQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHb8M2C0pBFuzA_Q+-zBkHT2ZckDKEkAvD0oiM900_ZhxxH2PQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 09:03:49AM +0900, DaeSeok Youn wrote:
> Hi, greg.
> 
> Review my comment below.

What comment?

confused,

greg k-h-
