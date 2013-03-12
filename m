Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081Ab3CLCKo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 22:10:44 -0400
Received: from host-176-100-244-43.masterbit.su ([176.100.244.43]:54857 "EHLO
	tservice.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754601Ab3CLCKn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 22:10:43 -0400
Date: Tue, 12 Mar 2013 06:10:42 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Johan Hovold <jhovold@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] w1-gpio: remove erroneous __exit and __exit_p()
Message-ID: <20130312021042.GB8181@ioremap.net>
References: <1362737280-13714-1-git-send-email-jhovold@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362737280-13714-1-git-send-email-jhovold@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Fri, Mar 08, 2013 at 11:07:59AM +0100, Johan Hovold (jhovold@gmail.com) wrote:
> Commit 8a1861d997 ("w1-gpio: Simplify & get rid of defines") changed
> (apparently unknowingly) the driver to a hotpluggable platform-device
> driver but did not not update the section markers for probe and remove
> (to __devinit/exit, which have since been removed). A later commit fixed
> the section mismatch for probe, but left remove marked with __exit.
> 
> Signed-off-by: Johan Hovold <jhovold@gmail.com>

Both patches look good to me, thank you
Greg, please pull it into your tree

Acked-by: Evgeniy Polyakov <zbr@ioremap.net>

-- 
	Evgeniy Polyakov
