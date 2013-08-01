Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668Ab3HAHad (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 03:30:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41713 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab3HAHac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 03:30:32 -0400
Date: Wed, 31 Jul 2013 18:11:50 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Cc: linux-serial@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Jiri Slaby <jslaby@suse.cz>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Gallimore <stephen.gallimore@st.com>,
        Stuart Menefy <stuart.menefy@st.com>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v7] serial:st-asc: Add ST ASC driver.
Message-ID: <20130801011150.GA11704@kroah.com>
References: <1375263408-12834-1-git-send-email-srinivas.kandagatla@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375263408-12834-1-git-send-email-srinivas.kandagatla@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 10:36:48AM +0100, Srinivas KANDAGATLA wrote:
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
> This patch is the part of the driver support for Sti ARM SOCs.
> This patch undergone 3-4 cycles of review in arm-kernel mailing list.
> All the patches in that series went into 3.11.
> This patch is based on 3.11-rc1.

This patch doesn't apply to my tree at all, can you please refresh it
against my tty-next tree and resend it so that I can have the chance to
apply it?

thanks,

greg k-h
