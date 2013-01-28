Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295Ab3A1MOK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 07:14:10 -0500
Received: from mx01.sz.bfs.de ([194.94.69.103]:14097 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756961Ab3A1MOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 07:14:08 -0500
X-Greylist: delayed 463 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Jan 2013 07:14:08 EST
Message-ID: <510669BF.9090706@bfs.de>
Date: Mon, 28 Jan 2013 13:06:23 +0100
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Paul Fulghum <paulkf@microgate.com>,
        David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] TTY: synclink, small cleanup in dtr_rts()
References: <20130127194039.GA18787@elgon.mountain>	 <1359317078.14406.12.camel@joe-AO722> <20130127201947.GO16282@mwanda> <1359320401.14406.16.camel@joe-AO722>
In-Reply-To: <1359320401.14406.16.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Am 27.01.2013 22:00, schrieb Joe Perches:
> On Sun, 2013-01-27 at 23:19 +0300, Dan Carpenter wrote:
>> On Sun, Jan 27, 2013 at 12:04:38PM -0800, Joe Perches wrote:
>>> Wouldn't it be clearer still to use | instead of +
>> Yeah.  I think it would be, but adding bitflags together instead of
>> doing bitwise ORs is very common as well.
> 
> Fortunately, less and less so.
> 
> Another option might be to add another #define
> to include/uapi/linux/synclink.h
> 
> #define SerialSignal_DTR_RTS	(SerialSignal_DTR | SerialSignal_RTS)


Do you really want every possible combination ready as define ?
please stay with: (SerialSignal_DTR | SerialSignal_RTS)
Everyone using serial should know about DTR and RTS

re,
 wh
