Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751126AbaKCXrU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 18:47:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34657 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbaKCXrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 18:47:18 -0500
Date: Mon, 3 Nov 2014 15:47:17 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jason Baron <jbaron@akamai.com>,
        linux-usb <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] printk: Add and use LOGLEVEL_<level> defines for
 KERN_<LEVEL> equivalents
Message-ID: <20141103234717.GB31777@kroah.com>
References: <1414964554.17743.7.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414964554.17743.7.camel@perches.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 02, 2014 at 01:42:34PM -0800, Joe Perches wrote:
> Use #defines instead of magic values.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

