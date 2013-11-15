Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053Ab3KOK76 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 05:59:58 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:18969 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753699Ab3KOK7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 05:59:50 -0500
Date: Fri, 15 Nov 2013 13:55:54 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Julien DELACOU <julien.delacou@st.com>
Cc: Paul Zimmerman <paulz@synopsys.com>, Matthijs Kooijman <matthijs@stdin.nl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>, devel@driverdev.osuosl.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: dwc2: do not clear pending interrupts twice
Message-ID: <20131115105553.GR5302@mwanda>
References: <1384511978-18770-1-git-send-email-julien.delacou@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384511978-18770-1-git-send-email-julien.delacou@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 11:39:38AM +0100, Julien DELACOU wrote:
> Pending interrupts clearing is done in dwc2_enable_common_interrupts
> so we don't need to do it twice.
> 

Are there any user visible effects to this bug?  How did you spot it?

regards,
dan carpenter


