Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933580AbaFLN52 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 09:57:28 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:36503 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933511AbaFLN5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 09:57:23 -0400
Date: Thu, 12 Jun 2014 16:57:00 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: navin patidar <navin.patidar@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 06/22] staging: rtl8188eu: Instead of intf_hdl pass
 adapter in read & write functions
Message-ID: <20140612135700.GX5015@mwanda>
References: <1402507301-3722-1-git-send-email-navin.patidar@gmail.com>
 <1402507301-3722-6-git-send-email-navin.patidar@gmail.com>
 <20140612074321.GT5500@mwanda>
 <CAPV97ydjB5_HT6Htvju-ng0PGYVBmiDWxY9A=vYq35vrubsWeQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPV97ydjB5_HT6Htvju-ng0PGYVBmiDWxY9A=vYq35vrubsWeQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 03:52:33PM +0530, navin patidar wrote:
> On Thu, Jun 12, 2014 at 1:13 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> > On Wed, Jun 11, 2014 at 10:51:25PM +0530, navin patidar wrote:
> >> diff --git a/drivers/staging/rtl8188eu/core/rtw_io.c b/drivers/staging/rtl8188eu/core/rtw_io.c
> >> index a0a31e6..85306bf 100644
> >> --- a/drivers/staging/rtl8188eu/core/rtw_io.c
> >> +++ b/drivers/staging/rtl8188eu/core/rtw_io.c
> >> @@ -57,10 +57,10 @@ u8 _rtw_read8(struct adapter *adapter, u32 addr)
> >>       u8 r_val;
> >>       struct io_priv *pio_priv = &adapter->iopriv;
> >>       struct  intf_hdl *pintfhdl = &(pio_priv->intf);
> >> -     u8 (*_read8)(struct intf_hdl *pintfhdl, u32 addr);
> >> +     u8 (*_read8)(struct adapter *pintfhdl, u32 addr);
> >                                      ^^^^^^^^
> > Could you send a follow on patch to change pintfhdl to adapter in all
> > the declarations?
> >
> 
> dan, these declarations are removed by other patches of this patch set.
> 
> do i still need to send v2 of this patch?

No.  That's fine, thanks.

regards,
dan carpenter

