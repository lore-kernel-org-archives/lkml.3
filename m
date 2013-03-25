Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548Ab3CYMsK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 08:48:10 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:57625 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756439Ab3CYMsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 08:48:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: Re: [PATCH 3/3] serial: of_serial: Handle hw-flow-control property
Date: Mon, 25 Mar 2013 12:47:58 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-13-generic; KDE/4.3.2; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Ley Foon Tan <lftan@altera.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
References: <1364211286-31611-1-git-send-email-heikki.krogerus@linux.intel.com> <201303251140.31866.arnd@arndb.de> <20130325122851.GB20052@xps8300>
In-Reply-To: <20130325122851.GB20052@xps8300>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303251247.58823.arnd@arndb.de>
X-Provags-ID: V02:K0:g2UBfTBLTkD2yoyujHbm2WRgMKRbp3r28uzw7zlBz3D
 a742v4Z34j9fqnk8p0ZatYkYb/CGr8wR5UE+dygPCrT1piGPMC
 7ZwXIDfNMIxLZVMtSCPfpQQpwVFoeb0rJymuPZSXk5YGmYXVxw
 BVjZl+XNeow27b7J2GTzn8FoMqY06lcIWKwi+E/46GtpPbJDT4
 VYmMTEM2qABdk+MHR91B946dsydTyQfOcYReo5DrJFOi4QYoWQ
 EH9sSbDD0nDr94aIYE0nv9NEX1kf3xgE4gXgRtFnE1RktskRQA
 aPJgOduV/ncjnQDqS5ntvqRWFcOF3TdD+TNLNxpJI5ycvBxO2t
 i0pEYnyAy+pKtgeNyEpk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 March 2013, Heikki Krogerus wrote:
> On Mon, Mar 25, 2013 at 11:40:31AM +0000, Arnd Bergmann wrote:
> > On Monday 25 March 2013, Heikki Krogerus wrote:
> > > This will add support for hardware flow control. It is
> > > limited to be used only with 8250 driver.
> > > 
> > > Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> > 
> > Does this imply that we can use hardware flow control only when this
> > flag is set in the device tree? I assumed that working flow control
> > would be the default. Is it not?
> 
> OK, the commit message is wrong. Is the patch otherwise OK?

I still find the text in the binding and the name of the property confusing,
because it seems to imply that you have no hardware flow control without this.
I think what you mean here is really "automatic flow control" rather than
"hardware flow control".

	Arnd
