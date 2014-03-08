Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116AbaCHTfI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 14:35:08 -0500
Received: from mail-vc0-f172.google.com ([209.85.220.172]:43549 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbaCHTfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 14:35:05 -0500
MIME-Version: 1.0
In-Reply-To: <1394219614-3197-12-git-send-email-soren.brinkmann@xilinx.com>
References: <1394219614-3197-1-git-send-email-soren.brinkmann@xilinx.com>
	<1394219614-3197-12-git-send-email-soren.brinkmann@xilinx.com>
Date: Sat, 8 Mar 2014 13:35:04 -0600
Message-ID: <CAL_Jsq+CUQ4p_NwJ7HvhNSUvkpge0+ZgPxYTWkx3dUNpRJ7trg@mail.gmail.com>
Subject: Re: [PATCH RFC v2 11/11] ARM: zynq: DT: Migrate UART to Cadence binding
From: Rob Herring <robherring2@gmail.com>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Arnd Bergmann <arnd@arndb.de>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-serial@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 7, 2014 at 1:13 PM, Soren Brinkmann
<soren.brinkmann@xilinx.com> wrote:
> The Zynq UART is Cadence IP and the driver has been renamed accordingly.
> Migrate the DT to use the new binding for the UART driver.
>
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> Acked-by: Peter Crosthwaite <peter.crosthwaite@xilinx.com>

Acked-by: Rob Herring <robh@kernel.org>
