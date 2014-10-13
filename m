Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174AbaJMBgM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 21:36:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45372 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126AbaJMBgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 21:36:07 -0400
Date: Mon, 13 Oct 2014 03:34:33 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Erich Cordoba Malibran <erich.cordoba@yandex.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH] Staging: wlan-ng: prism2 simple style modifications
Message-ID: <20141013013433.GE12633@kroah.com>
References: <1413132247-3667-1-git-send-email-erich.cordoba@yandex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413132247-3667-1-git-send-email-erich.cordoba@yandex.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 12, 2014 at 11:44:07AM -0500, Erich Cordoba Malibran wrote:
> From: Erich Cordoba <erich.cordoba@yandex.com>
> 
> prism2fw.c
> prism2sta.c
> 	Fixed style warning reported by checkpatch.pl
> prism2mib.c
> 	Renamed function prism2mib_framenthreshold to
> 	meet style guidelines.

You are doing multiple different things here in one patch.  Please break
it up into "one logical thing per patch" and resend them.

thanks,

greg k-h
