Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021AbaD1TLh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 15:11:37 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:51165 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753857AbaD1TLd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 15:11:33 -0400
Message-ID: <1398707568.23146.0.camel@violet>
Subject: Re: [PATCH v8 02/20] usb: phy: msm: Remove __init macro from driver
 probe method
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: balbi@ti.com
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Date: Mon, 28 Apr 2014 20:52:48 +0300
In-Reply-To: <20140428170357.GP30292@saruman.home>
References: <1398692063-11372-1-git-send-email-iivanov@mm-sol.com>
	 <1398692063-11372-3-git-send-email-iivanov@mm-sol.com>
	 <535E893B.7050609@cogentembedded.com> <20140428170357.GP30292@saruman.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-28 at 12:03 -0500, Felipe Balbi wrote:
> On Mon, Apr 28, 2014 at 09:00:43PM +0400, Sergei Shtylyov wrote:
> > Hello.
> > 
> > On 04/28/2014 05:34 PM, Ivan T. Ivanov wrote:
> > 
> > >From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> > 
> > >This fixes following:
> > 
> > >WARNING: drivers/usb/phy/built-in.o(.data+0x68): Section mismatch in reference from the variable msm_otg_driver to the function .init.text:msm_otg_probe()
> > >The variable msm_otg_driver references
> > >the function __init msm_otg_probe()
> > 
> >    Hm, this warning shouldn't occur before patch #4, no?
> 
> good catch, this could probably be merged there.

True. Should I resend it?

Regards,
Ivan


