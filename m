Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965768AbaFSVcr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 17:32:47 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:34139 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964833AbaFSVcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 17:32:46 -0400
X-Sasl-enc: RG51fGoApXyx61UIqhvgGVlCiYmbRWjWjqXwn7/Rk3FS 1403213565
Date: Thu, 19 Jun 2014 14:36:45 -0700
From: GregKH <greg@kroah.com>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Scott Alfter <scott@alfter.us>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: revised driver: w1_ds2406
Message-ID: <20140619213645.GA1139@kroah.com>
References: <31a597fc9f165ccc4998451b0ae91fc6.squirrel@webmail.alfter.us>
 <6295551403198966@web5h.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6295551403198966@web5h.yandex.ru>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 09:29:26PM +0400, Evgeniy Polyakov wrote:
> Hi Scott
> 
> I've added Greg to copy.
> 
> 18.06.2014, 00:42, "Scott Alfter" <scott@alfter.us>:
> > Some preliminary work at making use of this driver led me to implement
> > CRC-16 checks on read and write to deal with the occasional glitchiness of
> > the 1-Wire bus.  The revised driver (attached) returns an I/O error if the
> > CRC check fails.  When reading the chip's state, either you get a valid
> > indication or you get an I/O error.  When changing its state, either the
> > change is successful or an I/O error is returned.
> >
> > This patch supersedes the patch I had previously submitted.
> >
> > Signed-off-by: Scott Alfter <scott@alfter.us>
> 
> Greg, this patch looks good, please pull it into your tree.
> If you already applied previous ds2406, let us know.

I didn't, I'll take this one instead, thanks.

greg k-h
