Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028Ab3LDWAN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 17:00:13 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:58609 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383Ab3LDWAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 17:00:09 -0500
Date: Wed, 4 Dec 2013 13:57:52 -0800
From: Olof Johansson <olof@lixom.net>
To: srinivas.kandagatla@st.com
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        arnd@arndb.de
Subject: Re: [PATCH] ARM: multi_v7_defconfig: Fix STi support
Message-ID: <20131204215752.GA729@quad.lixom.net>
References: <1386162613-13492-1-git-send-email-srinivas.kandagatla@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386162613-13492-1-git-send-email-srinivas.kandagatla@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 01:10:13PM +0000, srinivas.kandagatla@st.com wrote:
> From: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> 
> This patch adds ST serial driver (st-asc) and ICPLUS ethernet PHY to
> multi_v7_defconfig. All STi based SOCs use ST-ASC as default serial
> console, and most of the STi SOC based boards have ICPLUS external
> ethernet PHY. These two options makes the system boot nfs root with
> console.
> 
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>


Applied, thanks.


-Olof
