Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894AbaCGVaV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 16:30:21 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:55979 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281AbaCGVaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 16:30:18 -0500
Date: Fri, 7 Mar 2014 21:29:44 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Arnd Bergmann <arnd@arndb.de>,
        Michal Simek <michal.simek@xilinx.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH RFC v2 06/11] tty: xuartps: Change driver name to
 'cdns-uart'
Message-ID: <20140307212944.4007c6f1@alan.etchedpixels.co.uk>
In-Reply-To: <1394219614-3197-7-git-send-email-soren.brinkmann@xilinx.com>
References: <1394219614-3197-1-git-send-email-soren.brinkmann@xilinx.com>
	<1394219614-3197-7-git-send-email-soren.brinkmann@xilinx.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  7 Mar 2014 11:13:29 -0800
Soren Brinkmann <soren.brinkmann@xilinx.com> wrote:

> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
> I'm not sure about this change. Is this acceptable or already too much?
> I think the name is used for some sysfs entries.

Its probably not a good idea. You might be ok depending whether anything
ever used the sysfs nodes.

Alan
