Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935929Ab3DKB5m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 21:57:42 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:58887 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933295Ab3DKB5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 21:57:41 -0400
Date: Wed, 10 Apr 2013 18:57:39 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: Re: [char-misc-next 0/3 v7] Support NFC device on MEI CL bus
Message-ID: <20130411015739.GA7520@kroah.com>
References: <1365642211-21421-1-git-send-email-sameo@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365642211-21421-1-git-send-email-sameo@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 03:03:28AM +0200, Samuel Ortiz wrote:
> v6 -> v7:
>    * Removed include/uapi/linux/mei/nfc.h.
>      All MEI NFC definitions are now folded into drivers/misc/mei/nfc.c

All now applied, thanks for the persistance.

greg k-h
