Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824Ab3GWCfj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 22:35:39 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:48186 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515Ab3GWCfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 22:35:38 -0400
Date: Mon, 22 Jul 2013 19:35:40 -0700
From: Olof Johansson <olof@lixom.net>
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Stuart Menefy <stuart.menefy@st.com>, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 2/2] ARM: STi: Set correct ARM ERRATAs.
Message-ID: <20130723023540.GA14983@quad.lixom.net>
References: <1373354752-26292-1-git-send-email-srinivas.kandagatla@st.com>
 <1373354793-26400-1-git-send-email-srinivas.kandagatla@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373354793-26400-1-git-send-email-srinivas.kandagatla@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 09, 2013 at 08:26:33AM +0100, Srinivas KANDAGATLA wrote:
> From: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> 
> Some of the ARM_ERRATA selection is not done in the initial SOC support
> patches. This patch selects 2 new ARM_ERRATA's and removes one which was
> actually fixed.

These entries should be sorted, and you inserted in random order.

I'll rearrange the order when applying.

(Patch applied with that change).

Thanks,

-Olof
