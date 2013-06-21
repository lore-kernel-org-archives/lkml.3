Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423168Ab3FUOxS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 10:53:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58635 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423039Ab3FUOxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 10:53:15 -0400
Date: Fri, 21 Jun 2013 07:53:14 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Jiri Slaby <jslaby@suse.cz>, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org,
        Stephen Gallimore <stephen.gallimore@st.com>,
        Stuart Menefy <stuart.menefy@st.com>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v4] serial:st-asc: Add ST ASC driver.
Message-ID: <20130621145314.GA5110@kroah.com>
References: <1371823617-17380-1-git-send-email-srinivas.kandagatla@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371823617-17380-1-git-send-email-srinivas.kandagatla@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 21, 2013 at 03:06:57PM +0100, Srinivas KANDAGATLA wrote:
> From: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> 
> This patch adds support to ASC (asynchronous serial controller)
> driver, which is basically a standard serial driver. This IP is common
> across all the ST parts for settop box platforms.
> 
> ASC is embedded in ST COMMS IP block. It supports Rx & Tx functionality.
> It support all industry standard baud rates.
> 
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> CC: Stephen Gallimore <stephen.gallimore@st.com>
> CC: Stuart Menefy <stuart.menefy@st.com>
> CC: Arnd Bergmann <arnd@arndb.de>
> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
> Hi Greg, 
> 
> As per your request am resend this patch.
> 
> This patch is the part of the driver support for Stixxxx SOCs.
> This patch undergone 3 cycles of review in arm-kernel mailing list.
> As Arnd prefered to take only SOC support patches via arm-soc, am 
> sending this patch seperately.

Please redo this patch against the tty-next branch of my tty.git tree on
git.kernel.org.  As it is, there are conflicts that you need to resolve
in order for it to work and apply properly.

thanks,

greg k-h
