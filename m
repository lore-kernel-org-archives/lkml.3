Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbaFRWKg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 18:10:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52955 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026AbaFRWKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 18:10:34 -0400
Date: Thu, 19 Jun 2014 00:10:31 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Johan Hovold <johan@kernel.org>
cc: Janne Kanniainen <janne.kanniainen@gmail.com>, cooloney@gmail.com,
        linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH v9] leds: USB: HID: Add support for MSI GT683R led
 panels
In-Reply-To: <20140618161150.GH31163@localhost>
Message-ID: <alpine.LNX.2.00.1406190009560.2303@pobox.suse.cz>
References: <20140618073950.GC31163@localhost> <1403107502-14106-1-git-send-email-janne.kanniainen@gmail.com> <20140618161150.GH31163@localhost>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2014, Johan Hovold wrote:

> > This driver adds support for USB controlled led panels that exists in
> > MSI GT683R laptop
> > 
> > Signed-off-by: Janne Kanniainen <janne.kanniainen@gmail.com>
> 
> Reviewed-by: Johan Hovold <johan@kernel.org>
> 
> Thanks, Janne!

Now applied. Thanks Janne for the driver, and thanks a lot Johan for a 
very careful review, I really appreciate it.

-- 
Jiri Kosina
SUSE Labs
