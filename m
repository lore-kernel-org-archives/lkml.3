Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933152AbaD1Tlf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 15:41:35 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:52850 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932521AbaD1Tld (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 15:41:33 -0400
Message-ID: <1398707855.23146.1.camel@violet>
Subject: Re: [PATCH v8 02/20] usb: phy: msm: Remove __init macro from driver
 probe method
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: balbi@ti.com
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Date: Mon, 28 Apr 2014 20:57:35 +0300
In-Reply-To: <20140428175443.GT30292@saruman.home>
References: <1398692063-11372-1-git-send-email-iivanov@mm-sol.com>
	 <1398692063-11372-3-git-send-email-iivanov@mm-sol.com>
	 <535E893B.7050609@cogentembedded.com> <20140428170357.GP30292@saruman.home>
	 <1398707568.23146.0.camel@violet> <20140428175443.GT30292@saruman.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-28 at 12:54 -0500, Felipe Balbi wrote:
> On Mon, Apr 28, 2014 at 08:52:48PM +0300, Ivan T. Ivanov wrote:
> > On Mon, 2014-04-28 at 12:03 -0500, Felipe Balbi wrote:
> > > On Mon, Apr 28, 2014 at 09:00:43PM +0400, Sergei Shtylyov wrote:
> > > > Hello.
> > > > 
> > > > On 04/28/2014 05:34 PM, Ivan T. Ivanov wrote:
> > > > 
> > > > >From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> > > > 
> > > > >This fixes following:
> > > > 
> > > > >WARNING: drivers/usb/phy/built-in.o(.data+0x68): Section mismatch in reference from the variable msm_otg_driver to the function .init.text:msm_otg_probe()
> > > > >The variable msm_otg_driver references
> > > > >the function __init msm_otg_probe()
> > > > 
> > > >    Hm, this warning shouldn't occur before patch #4, no?
> > > 
> > > good catch, this could probably be merged there.
> > 
> > True. Should I resend it?
> 
> hold on, that's simple enough to sort out while applying. Unless there
> are any other big comments with your series, no need to resend.

Sure, I will wait for more comments.

Thanks,
Ivan

> 
> cheers
> 


