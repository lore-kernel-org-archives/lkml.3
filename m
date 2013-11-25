Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001Ab3KYUnk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 15:43:40 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56389 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab3KYUnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 15:43:37 -0500
Date: Mon, 25 Nov 2013 12:43:36 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH staging-next 0/4] fwserial changes for 3.14
Message-ID: <20131125204336.GA646@kroah.com>
References: <1385143571-3571-1-git-send-email-peter@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385143571-3571-1-git-send-email-peter@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 01:06:07PM -0500, Peter Hurley wrote:
> **This patchset requires 'Halve tty buffer memory consumption' patchset **

Requires it to build or just work properly?

I'm trying to figure out what tree to take this in, (tty-next or
staging-next).

thanks,

greg k-h
