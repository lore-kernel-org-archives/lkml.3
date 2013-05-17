Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116Ab3EQDue (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 23:50:34 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:37496 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754852Ab3EQDu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 23:50:28 -0400
X-Sasl-enc: I40Z0lUP+wztpDjJS1KcaHk8cVL07cqa0GZU5GdAU6YQ 1368762134
Date: Thu, 16 May 2013 17:36:55 -0700
From: Greg KH <greg@kroah.com>
To: Libo Chen <clbchenlibo.chen@huawei.com>
Cc: stern@rowland.harvard.edu, grant.likely@linaro.org,
        rob.herring@calxeda.com, linux-usb@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "lizefan@huawei.com >> Li Zefan" <lizefan@huawei.com>
Subject: Re: [PATCH v2] usb: ohci: fix goto wrong tag in err case
Message-ID: <20130517003655.GA19379@kroah.com>
References: <518C9232.1000803@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <518C9232.1000803@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 02:22:42PM +0800, Libo Chen wrote:
> fix goto wrong tag in usb_hcd_nxp_probe
> 
> Signed-off-by: Libo Chen <libo.chen@huawei.com>

Ah, you redid this, nevermind about the v1 of this patch, sorry...
