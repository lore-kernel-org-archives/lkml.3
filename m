Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503Ab3EJOWn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:22:43 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:39951 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756443Ab3EJOWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:22:42 -0400
Date: Fri, 10 May 2013 10:22:40 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Libo Chen <clbchenlibo.chen@huawei.com>
cc: grant.likely@linaro.org, <rob.herring@calxeda.com>,
        <linux-usb@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "lizefan@huawei.com >> Li Zefan" <lizefan@huawei.com>
Subject: Re: [PATCH v2] usb: ohci: fix goto wrong tag in err case
In-Reply-To: <518C9232.1000803@huawei.com>
Message-ID: <Pine.LNX.4.44L0.1305101022120.1313-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 May 2013, Libo Chen wrote:

> fix goto wrong tag in usb_hcd_nxp_probe
> 
> * Changelog from v1:
>     * instead of all these statement labels suggested by Alan Stern
> 
> Signed-off-by: Libo Chen <libo.chen@huawei.com>

That's a lot better.  Thanks for redoing all this.

Acked-by: Alan Stern <stern@rowland.harvard.edu>

