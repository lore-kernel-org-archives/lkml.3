Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724AbaD1HU0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 03:20:26 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:51987 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753423AbaD1HUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 03:20:16 -0400
Message-ID: <1398669562.5214.12.camel@iivanov-dev>
Subject: Re: [PATCH v7 20/20] usb: phy: msm: Use usb_add_phy_dev() to
 register device
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: balbi@ti.com
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Date: Mon, 28 Apr 2014 10:19:22 +0300
In-Reply-To: <20140425205346.GN29632@saruman.home>
References: <1398354495-20782-1-git-send-email-iivanov@mm-sol.com>
	 <1398354495-20782-21-git-send-email-iivanov@mm-sol.com>
	 <53594490.7040205@cogentembedded.com> <20140425205346.GN29632@saruman.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.1-2ubuntu2~saucy1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-04-25 at 15:53 -0500, Felipe Balbi wrote:
> On Thu, Apr 24, 2014 at 09:06:24PM +0400, Sergei Shtylyov wrote:
> > Hello.
> > 
> > On 04/24/2014 07:48 PM, Ivan T. Ivanov wrote:
> > 
> > >From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> > 
> > >They could be more than one USB2.0 PHY's on the platform.
> > 
> >    s/They/There/
> > 
> > >This will allow all of them to be registred successfuly.
> > 
> >    s/registred successfuly/registered successfully/

Ouch. will fix it.

Regards,
Ivan


