Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758AbaJJJqA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 05:46:00 -0400
Received: from filter1.ibarracuda.nl ([83.247.7.10]:45370 "EHLO
	filter1.ibarracuda.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961AbaJJJp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 05:45:59 -0400
X-ASG-Debug-ID: 1412934356-0759e74828420cd0002-xx1T2L
X-Barracuda-Envelope-From: Frans.Klaver@xsens.com
X-Barracuda-AUTH-User: xsenscom
X-Barracuda-Apparent-Source-IP: 87.249.116.215
Date: Fri, 10 Oct 2014 11:45:55 +0200
From: Frans Klaver <frans.klaver@xsens.com>
To: Johan Hovold <johan@kernel.org>
CC: <stable@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] usb: serial: ftdi_sio: add Awinda Station and Dongle
 products
Message-ID: <20141010094555.GE3588@ci00147.xsens-tech.local>
X-ASG-Orig-Subj: Re: [PATCH v2] usb: serial: ftdi_sio: add Awinda Station and Dongle
 products
References: <1412930694-28769-1-git-send-email-frans.klaver@xsens.com>
 <1412933547-10906-1-git-send-email-frans.klaver@xsens.com>
 <20141010093443.GD12494@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20141010093443.GD12494@localhost>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [172.16.11.125]
X-Barracuda-Connect: rev-215.116.249.87.virtu.nl[87.249.116.215]
X-Barracuda-Start-Time: 1412934356
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://filter1.ibarracuda.nl:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.10404
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2014 at 11:34:43AM +0200, Johan Hovold wrote:
> On Fri, Oct 10, 2014 at 11:32:27AM +0200, Frans Klaver wrote:
> > Add new IDs for the Xsens Awinda Station and Awinda Dongle.
> > 
> > While at it, order the definitions by PID and add a logical separation
> > between devices using Xsens' VID and those using FTDI's VID.
> > 
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Frans Klaver <frans.klaver@xsens.com>
> > ---
> >  drivers/usb/serial/ftdi_sio.c     | 2 ++
> >  drivers/usb/serial/ftdi_sio_ids.h | 6 +++++-
> >  2 files changed, 7 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
> > index dc72b92..e4eccb6 100644
> > --- a/drivers/usb/serial/ftdi_sio.c
> > +++ b/drivers/usb/serial/ftdi_sio.c
> > @@ -661,6 +661,8 @@ static const struct usb_device_id id_table_combined[] = {
> >  	{ USB_DEVICE(FTDI_VID, XSENS_CONVERTER_5_PID) },
> >  	{ USB_DEVICE(FTDI_VID, XSENS_CONVERTER_6_PID) },
> >  	{ USB_DEVICE(FTDI_VID, XSENS_CONVERTER_7_PID) },
> > +	{ USB_DEVICE(XSENS_VID, XSENS_AWINDA_STATION_PID) },
> > +	{ USB_DEVICE(XSENS_VID, XSENS_AWINDA_DONGLE_PID) },
> 
> These are still not in alphabetical order. :)

*goes and hides in the woods*

Frans
