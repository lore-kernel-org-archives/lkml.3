Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389AbaCTBsA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 21:48:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51671 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226AbaCTBr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 21:47:58 -0400
Date: Thu, 20 Mar 2014 01:49:19 +0000
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: =?iso-8859-1?Q?C=E9dric?= Cabessa <ced@ryick.net>
Cc: linux-usb@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] coding style: fix quoted string split across lines
Message-ID: <20140320014919.GA9312@kroah.com>
References: <1395266697-8699-1-git-send-email-ced@ryick.net>
 <1395266697-8699-2-git-send-email-ced@ryick.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1395266697-8699-2-git-send-email-ced@ryick.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 11:04:56PM +0100, Cédric Cabessa wrote:
> Signed-off-by: Cédric Cabessa <ced@ryick.net>

In the future, please pick a subject line that says what part of the
kernel you are changing.  For example, this patch would be:
	staging: usbip: fix quoted string split across lines

I'll fix these 2 up but in the future, please be more explicit.

thanks,

greg k-h
