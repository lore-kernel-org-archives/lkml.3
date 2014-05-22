Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125AbaEVJcH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 05:32:07 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:46957 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbaEVJcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 05:32:05 -0400
MIME-Version: 1.0
In-Reply-To: <20140522091720.GH15585@mwanda>
References: <20140522085339.26279.83340.sendpatchset@w520>
	<20140522091720.GH15585@mwanda>
Date: Thu, 22 May 2014 18:32:03 +0900
Message-ID: <CANqRtoTaaS8UAA7UdmMFDXnZ1c71m_Poo7VY9+3fDx0Q5PAw2Q@mail.gmail.com>
Subject: Re: [PATCH 00/03] staging: Emma Mobile USB driver and KZM9D board code
From: Magnus Damm <magnus.damm@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        driverdevel <devel@driverdev.osuosl.org>,
        SH-Linux <linux-sh@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Simon Horman [Horms]" <horms@verge.net.au>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

On Thu, May 22, 2014 at 6:17 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> Generally we take things as is into staging so there is no need for a
> re-work if you don't want to.  But we do need a TODO file.  Read the
> TODO files for other staging drivers.

Thanks for pointing that out, my apologies for being random and
skipping that! I will add a TODO file to v2!

Cheers,

/ magnus

On Thu, May 22, 2014 at 6:17 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> Generally we take things as is into staging so there is no need for a
> re-work if you don't want to.  But we do need a TODO file.  Read the
> TODO files for other staging drivers.
>
> regards,
> dan carpenter
>
