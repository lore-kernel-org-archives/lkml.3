Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845AbaDOSIg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 14:08:36 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:54166 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751369AbaDOSIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 14:08:34 -0400
Message-ID: <1397585312.8212.13.camel@x220>
Subject: Re: [PATCH] usb: phy: mv_u3d: Remove usb phy driver for mv_u3d
From: Paul Bolle <pebolle@tiscali.nl>
To: balbi@ti.com
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Richard Weinberger <richard@nod.at>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Date: Tue, 15 Apr 2014 20:08:32 +0200
In-Reply-To: <20140415172310.GD16002@saruman.home>
References: <1397561783.1985.55.camel@x220>
	 <20140415172310.GD16002@saruman.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Apr 2014 18:08:32.0729 (UTC) FILETIME=[B6544C90:01CF58D5]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-15 at 12:23 -0500, Felipe Balbi wrote:
> so this means that drivers/usb/gadget/mv_u3d_core.c isn't used either ?

Why should it? There's no dependency on CPU_MMP3 for USB_MV_U3D anymore,
is there?

> Instead of deleting this and introducing a new driver, why don't you
> just help fix what's already in-tree ?

Were any of the reasons I gave for removing this driver incorrect? Has
it actually ever been possible to build it?


Paul Bolle

