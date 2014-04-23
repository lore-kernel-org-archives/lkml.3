Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827AbaDWNgE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 09:36:04 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:60333 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753434AbaDWNf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 09:35:59 -0400
Message-ID: <1398260102.4724.223.camel@iivanov-dev>
Subject: Re: [PATCH v6 15/19] usb: phy: msm: Fix PTS definitions for MSM USB
 controller
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Felipe Balbi <balbi@ti.com>, Tim Bird <tbird20d@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Tim Bird <tim.bird@sonymobile.com>
Date: Wed, 23 Apr 2014 16:35:02 +0300
In-Reply-To: <1398259477.4724.218.camel@iivanov-dev>
References: <1398158438-21579-1-git-send-email-iivanov@mm-sol.com>
	 <1398158438-21579-16-git-send-email-iivanov@mm-sol.com>
	 <53566A23.8010508@cogentembedded.com>
	 <1398259477.4724.218.camel@iivanov-dev>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.1-2ubuntu2~saucy1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-23 at 16:24 +0300, Ivan T. Ivanov wrote:

> > > --- a/include/linux/usb/msm_hsusb_hw.h
> > > +++ b/include/linux/usb/msm_hsusb_hw.h
> > > @@ -31,8 +31,9 @@
> > >   #define USB_USBINTR          (MSM_USB_BASE + 0x0148)
> > >
> > >   #define PORTSC_PHCD            (1 << 23) /* phy suspend mode */
> > > -#define PORTSC_PTS_MASK         (3 << 30)
> > > -#define PORTSC_PTS_ULPI         (3 << 30)
> > > +#define PORTSC_PTS_MASK        (3 << 30)
> > > +#define PORTSC_PTS_ULPI        (2 << 30)
> > > +#define PORTSC_PTS_SERIAL      (3 << 30)
> > 
> >     Please use tabs, not spaces here.
> 
> Thanks, will fix and resend.

I answered too quickly. File contain tabs and spaces for
indentation of definitions. Should I still use tabs here?

Regards,
Ivan

> 
> Ivan
> 
> > 
> > WBR, Sergei
> > 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arm-msm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


