Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894Ab3FXRyL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 13:54:11 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:52638 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762Ab3FXRyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 13:54:08 -0400
Date: Mon, 24 Jun 2013 10:54:15 -0700
From: Olof Johansson <olof@lixom.net>
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Cc: linux-arm-kernel@lists.infradead.org, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Stuart Menefy <stuart.menefy@st.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@stlinux.com,
        Arnd Bergmann <arnd@arndb.de>,
        Stephen Gallimore <stephen.gallimore@st.com>
Subject: Re: [PATCH v4 0/7] ARM:STixxxx: Add STixxxx platform and board
 support
Message-ID: <20130624175415.GA31429@quad.lixom.net>
References: <1371811076-27168-1-git-send-email-srinivas.kandagatla@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371811076-27168-1-git-send-email-srinivas.kandagatla@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 21, 2013 at 11:37:56AM +0100, Srinivas KANDAGATLA wrote:
> From: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> 
> Thankyou all for reviewing the v3 patches.
> 
> This patch-set adds basic support for STMicroelectronics STixxxx SOCs
> which includes STiH415 and STiH416 with B2000 and B2020 board support.
> 
> STiH415 and STiH416 are dual-core ARM Cortex-A9 CPU, designed for use in
> Set-top-boxes. The SOC support is available in mach-stixxxx which contains
> support code for STiH415, STiH416 SOCs including the generic board support.
> 
> The reason for adding two SOCs at this patch set is to show that no new
> C code is required for second SOC(STiH416) support.
> 
> This patch-set only contains the SOC support, all the driver support for
> this platform are submitted to respective mailing lists.

Hi,

I think these are looking quite reasonable, and I am ready to apply them
to 3.11.

However, I have one bikeshed comment. I find the name of the platform to be
awkward. Would you mind naming it mach-sti instead?


-Olof

