Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237Ab3EQWIX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 18:08:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54954 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932107Ab3EQWIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 18:08:20 -0400
Date: Fri, 17 May 2013 15:08:19 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Severin Gsponer <svgsponer@gmail.com>
Cc: Kevin McKinney <klmckinney1@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Staging: bcm: Fix of various code style issues.
Message-ID: <20130517220819.GA11038@kroah.com>
References: <1368801862-24405-1-git-send-email-svgsponer@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368801862-24405-1-git-send-email-svgsponer@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 17, 2013 at 04:44:22PM +0200, Severin Gsponer wrote:
> Changed comment style to C89 in Version.h
> Fixed some whitespace issues in Typedefs.h
> Changed comment style to C89 in vendorspecificextn.c

You are doing 3 different things, so this should be at least 3 different
patches, right?

Please split them up and resend them, thanks.

greg k-h
