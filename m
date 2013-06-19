Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935134Ab3FSUnu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 16:43:50 -0400
Received: from mail.active-venture.com ([67.228.131.205]:55313 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934858Ab3FSUnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 16:43:49 -0400
X-Originating-IP: 108.223.40.66
Date: Wed, 19 Jun 2013 13:43:48 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Fabio Estevam <festevam@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Michael Ellerman <michael@ellerman.id.au>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Nightly stable builds [Was: fec: Fix build for MCF5272]
Message-ID: <20130619204348.GA7314@roeck-us.net>
References: <1371575099-2962-1-git-send-email-linux@roeck-us.net>
 <CAOMZO5CU57Jqtzt2ZX=TYiemn5okASo4GU_zer+j736J8yj0OQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMZO5CU57Jqtzt2ZX=TYiemn5okASo4GU_zer+j736J8yj0OQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 10:42:36AM -0300, Fabio Estevam wrote:
> Hi Guenter,
> 
> FYI
> 
> I asked Stephen to include m5272c3_defconfig as part of his daily
> build and now it is available:
> http://kisskb.ellerman.id.au/kisskb/buildresult/8991795/
> 
Nice front-end.

Greg, would it be useful to set up something similar for pending stable builds ?
I have back-end code doing that running on one of my servers at home, but no
web front-end.

Any idea whom to talk to to set this up ? Stephen ? Michael ?

Thanks,
Guenter
