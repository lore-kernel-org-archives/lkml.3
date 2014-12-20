Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158AbaLTM77 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 07:59:59 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:45098 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbaLTM74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 07:59:56 -0500
Date: Sat, 20 Dec 2014 04:59:52 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH v2 1/2] usb: serial: handle -EPROTO quietly in
 generic_read_bulk
Message-ID: <20141220125952.GA1424@newt.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Johan Hovold <johan@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
References: <1418340594-30469-1-git-send-email-jmmahler@gmail.com>
 <1419066698-2684-1-git-send-email-jmmahler@gmail.com>
 <1419066698-2684-2-git-send-email-jmmahler@gmail.com>
 <54956C6A.4060703@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54956C6A.4060703@cogentembedded.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergei,

On Sat, Dec 20, 2014 at 03:32:42PM +0300, Sergei Shtylyov wrote:
> Hello.
> 
> On 12/20/2014 12:11 PM, Jeremiah Mahler wrote:
> 
> >If a USB serial device driver, which is built using the generic serial
> >driver, is unplugged while there is an active program using the device,
> 
>    Driver is unplugged? :-)
> 
Yes, that doesn't make sense.  Good catch, thanks :-)

> >it will spam the logs with -EPROTO (71) messages as it attempts to
> >retry.
> 
> >Most serial usb drivers (metro-usb, pl2303, mos7840, ...) only output
> >these messages for debugging.  The generic driver treats these as
> >errors.
> 
> >Change the default output for the generic serial driver from error to
> >debug.
> 
> >Signed-off-by: Jeremiah Mahler <jmmahler@gmail.com>
> 
> [...]
> 
> WBR, Sergei
> 

-- 
- Jeremiah Mahler
