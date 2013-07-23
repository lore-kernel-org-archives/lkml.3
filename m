Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979Ab3GWCfv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 22:35:51 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:41271 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754884Ab3GWCfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 22:35:50 -0400
Date: Mon, 22 Jul 2013 19:35:52 -0700
From: Olof Johansson <olof@lixom.net>
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Stuart Menefy <stuart.menefy@st.com>, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 1/2] ARM: dts: STi: Fix pinconf setup for STiH416
 serial2
Message-ID: <20130723023552.GB14983@quad.lixom.net>
References: <1373354752-26292-1-git-send-email-srinivas.kandagatla@st.com>
 <1373354784-26357-1-git-send-email-srinivas.kandagatla@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373354784-26357-1-git-send-email-srinivas.kandagatla@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 09, 2013 at 08:26:24AM +0100, Srinivas KANDAGATLA wrote:
> From: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> 
> This patch fixes a bug in pinctrl setup of serial2 device, Some of the
> pins in the pinctrl node of serial2 do not belong to that
> pin-controller. This patch divides them in the pins into there
> respective pin controller nodes.
> 
> Without this patch serial on StiH416-B2000 Board will not work as it
> fails with:
> 
> "st-pinctrl pin-controller-rear.3: failed to get pin(99) name
> st-pinctrl pin-controller-rear.3: maps: function serial2 group serial2-0
> num 4
> pinconfig core: failed to register map default (3): no group/pin given"
> 
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>

Applied to fixes, thanks.


-Olof
