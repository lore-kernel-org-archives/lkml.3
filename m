Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345Ab3A0VAG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 16:00:06 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:34706 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756250Ab3A0VAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 16:00:03 -0500
Message-ID: <1359320401.14406.16.camel@joe-AO722>
Subject: Re: [patch] TTY: synclink, small cleanup in dtr_rts()
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Paul Fulghum <paulkf@microgate.com>,
        David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Date: Sun, 27 Jan 2013 13:00:01 -0800
In-Reply-To: <20130127201947.GO16282@mwanda>
References: <20130127194039.GA18787@elgon.mountain>
	 <1359317078.14406.12.camel@joe-AO722> <20130127201947.GO16282@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-01-27 at 23:19 +0300, Dan Carpenter wrote:
> On Sun, Jan 27, 2013 at 12:04:38PM -0800, Joe Perches wrote:
> > Wouldn't it be clearer still to use | instead of +
> Yeah.  I think it would be, but adding bitflags together instead of
> doing bitwise ORs is very common as well.

Fortunately, less and less so.

Another option might be to add another #define
to include/uapi/linux/synclink.h

#define SerialSignal_DTR_RTS	(SerialSignal_DTR | SerialSignal_RTS)

