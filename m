Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579AbaLSW6e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 17:58:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43626 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbaLSW6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 17:58:33 -0500
Date: Fri, 19 Dec 2014 14:58:32 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Robert Nachlinger <robert.nachlinger@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Robert Nachlinger <robert.nachlinger@googlemail.com>
Subject: Re: [PATCH] Staging: gdm724x: fix space before comma coding style
 issue in gdm_mux.c
Message-ID: <20141219225832.GA24045@kroah.com>
References: <1418921189-31372-1-git-send-email-robert.nachlinger@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418921189-31372-1-git-send-email-robert.nachlinger@googlemail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2014 at 05:46:29PM +0100, Robert Nachlinger wrote:
> This is a patch to the gdm_mux.c file that fixes a space before comma coding style issue found by the checkpatch.pl tool.

Can you fix up your line to be line-wrapped at 72 columns so I don't
have to do it by hand?

thanks,

greg k-h
