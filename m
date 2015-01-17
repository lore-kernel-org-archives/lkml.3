Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158AbbAQWOC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 17:14:02 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55202 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbbAQWOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 17:14:00 -0500
Date: Sat, 17 Jan 2015 13:50:40 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Emil Renner Berthing <kernel@esmil.dk>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Jes Sorensen <Jes.Sorensen@redhat.com>, devel@driverdev.osuosl.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: staging: rtl8723au: get rid of unneeded
 memset/memcpy
Message-ID: <20150117215040.GA16839@kroah.com>
References: <1417963040-9014-1-git-send-email-kernel@esmil.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417963040-9014-1-git-send-email-kernel@esmil.dk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 07, 2014 at 03:37:20PM +0100, Emil Renner Berthing wrote:
> This also fixes a sparse warning.

What sparse warning?  What's wrong with the original code?  Unless Jes
resends this to me, I don't see the need to apply it, sorry.

greg k-h
