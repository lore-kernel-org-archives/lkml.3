Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143AbaJMOtY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 10:49:24 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:51562 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286AbaJMOtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 10:49:23 -0400
Message-ID: <1413211759.9362.103.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: Regarding tx-nocache-copy in the Sheevaplug
From: Eric Dumazet <eric.dumazet@gmail.com>
To: =?ISO-8859-1?Q?Llu=EDs?= Batlle i Rossell <viric@viric.name>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        Carles =?ISO-8859-1?Q?Pag=E8s?= <page@cubata.homelinux.net>,
        linux-arm-kernel@lists.infradead.org
Date: Mon, 13 Oct 2014 07:49:19 -0700
In-Reply-To: <20141013143138.GJ1972@vicerveza.homeunix.net>
References: <20141013105246.GD1972@vicerveza.homeunix.net>
	 <20141013142156.GE26864@lunn.ch>
	 <20141013143138.GJ1972@vicerveza.homeunix.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-10-13 at 16:31 +0200, Lluís Batlle i Rossell wrote:
> Enabling tx offload and disabling tx-nocache-copy, making the machine *send* a
> lot of ssh traffic (sftp for example) makes ssh fail HMAC. It's quite easy to
> reproduce here.
> 
> As for the hardware, it's an old sheevaplug board.


Have you tried disabling TSO only, and are you using the latest kernel ?

Ezequiel Garcia added lot of changes recently.


