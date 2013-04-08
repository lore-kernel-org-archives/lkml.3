Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934676Ab3DHROm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 13:14:42 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:64355 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934432Ab3DHROk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 13:14:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH V5 0/6] USB: EHCI multiplatform for 3.10
Date: Mon, 8 Apr 2013 19:14:30 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-usb@vger.kernel.org, Manjunath Goudar <manjunath.goudar@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>
References: <1364919844-1726-1-git-send-email-arnd@arndb.de> <20130408164209.GA13694@kroah.com>
In-Reply-To: <20130408164209.GA13694@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304081914.30266.arnd@arndb.de>
X-Provags-ID: V02:K0:YnxLctz8hyr4gmIOW2FuAUEhYzW1l/959HoQAbTQZen
 D80ulGRrvamMFdE1sGf9E9MAPbEbidqwFPSOgcbErRaoHpQ9yf
 2vCc41bEhfKHaX8I+uXSGtIu23cgEEgk2iIGnclAfcL1iAA8iO
 oX4CsZCTRYIlqcwHlzf0WlIoZpHxx9j79Nr6A77DVXJQznwe50
 9V+pjJst3gFkI3RX1lJaANSPtTN15V0TbZ3RLAeQeAgPD6Iqe1
 lQ7JMA+RD8f/5zidLFlBs3p2o6j9q6gYnCf2ESmx9crWeYF1Jn
 jkCEguQcwct9xSrmAzremmOMVDBB1UzqvIIT9E/d48mdVds+9m
 ibnPp69d47SrLT2ghkUg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 April 2013, Greg KH wrote:
> On Tue, Apr 02, 2013 at 06:23:58PM +0200, Arnd Bergmann wrote:
> > Hi Greg,
> > 
> > Here are the EHCI patches that I think are good for inclusion in 3.10,
> > I hope you are willing to include them after the debacle over these
> > patches in 3.9.
> > 
> > The patches are all logically independent but sorted by priority,
> > so decide for yourself how many you want to take, starting at the
> > first one. The first six patches all have an Ack from Alan Stern
> > and from the respective ARM platform maintainers.
> 
> I don't see an ACK for the 6th patch from Alan, any reason for that?
> 
> I've applied the first 5 for now, if you want the 6th one applied,
> please resend.

Thanks a lot!

I had mentioned the fact that the last one is missing the ack in my
email, maybe not prominently enough when I wrote:

> > * The final patch is from me and still waiting for an Ack from Alan
> >   Stern, so please wait for his feedback before applying that one.

It would be nice to get that in, but it's not as important for 3.10 since
the only conflict between backends I expect is between Exynos and SPEAr.
SPEAr is not widely used for all I can tell, and whether Exynos actually
makes the multiplatform conversion is still an open question, since there
are a number of missing patches and we are about to close the window for
arm-soc patches as well. In 3.11, things will look quite different.

	Arnd
