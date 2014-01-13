Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135AbaAMVI7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 16:08:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52476 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844AbaAMVI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 16:08:56 -0500
Date: Mon, 13 Jan 2014 13:09:32 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Joe Borg <cyborg101010@gmail.com>
Cc: dan.carpenter@oracle.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, abbotti@mev.co.uk
Subject: Re: [PATCH] DAS1800: Fixing foo * bar should be foo *bar
Message-ID: <20140113210932.GA17131@kroah.com>
References: <1389644086-6574-1-git-send-email-cyborg101010@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389644086-6574-1-git-send-email-cyborg101010@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 08:14:46PM +0000, Joe Borg wrote:
> Signed-off-by Joe Borg <cyborg101010@gmail.com>

You need a changelog comment here, please.

And is that your "real" email address and name?

greg k-h
