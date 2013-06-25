Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295Ab3FYUqq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 16:46:46 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:33621 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775Ab3FYU3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 16:29:54 -0400
Date: Tue, 25 Jun 2013 13:30:02 -0700
From: Olof Johansson <olof@lixom.net>
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Cc: linux-arm-kernel@lists.infradead.org, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Stuart Menefy <stuart.menefy@st.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@stlinux.com,
        Arnd Bergmann <arnd@arndb.de>,
        Stephen Gallimore <stephen.gallimore@st.com>
Subject: Re: [PATCH v5 0/7] ARM:sti: Add STiH415/STiH416 platform and board
 support
Message-ID: <20130625203002.GA15068@quad.lixom.net>
References: <1372158822-19160-1-git-send-email-srinivas.kandagatla@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372158822-19160-1-git-send-email-srinivas.kandagatla@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 12:13:42PM +0100, Srinivas KANDAGATLA wrote:
> From: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> 
> This patch-set adds basic support for STMicroelectronics STi series SOCs
> which includes STiH415 and STiH416 with B2000 and B2020 board support.
> 
> STiH415 and STiH416 are dual-core ARM Cortex-A9 CPU, designed for use in
> Set-top-boxes. The SOC support is available in mach-sti which contains
> support code for STiH415, STiH416 SOCs including the generic board support.
> 
> The reason for adding two SOCs at this patch set is to show that no new
> C code is required for second SOC(STiH416) support.
> 
> This patch-set only contains the SOC support, all the driver support for
> this platform are submitted to respective mailing lists.
> 
> Changes since v4:
> 	- Renamed mach-stixxxx to mach-sti as suggested by Olof J.

Thanks!

I've merged this into next/late, and I'll drop the previous test merge by Arnd
of the last version of the patch set.


-Olof
