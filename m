Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606AbaGQS2a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 14:28:30 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:32902 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbaGQS22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 14:28:28 -0400
Date: Thu, 17 Jul 2014 13:28:25 -0500
From: Andy Gross <agross@codeaurora.org>
To: kiran.padwal@smartplayin.com
Cc: jackp@codeaurora.org, linux-arm-msm@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Kumar Gala <galak@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [Patch v7 2/3] usb: phy: Add Qualcomm DWC3 HS/SS PHY drivers
Message-ID: <20140717182825.GA17951@qualcomm.com>
References: <1404144233-17222-1-git-send-email-agross@codeaurora.org>
 <1404144233-17222-3-git-send-email-agross@codeaurora.org>
 <CA+neC=McWS8=iSi2XShJyvc85Aw4PSmF-osNpVgJv42d9or1WQ@mail.gmail.com>
 <1405593024.423213197@apps.rackspace.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405593024.423213197@apps.rackspace.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 06:30:24AM -0400, kiran.padwal@smartplayin.com wrote:
> Hi,
> 
> On Mon, Jun 30, 2014 at 9:33 PM, Andy Gross <agross@codeaurora.org> wrote: 
> > From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> > 
> > These drivers handles control and configuration of the HS
> > and SS USB PHY transceivers. They are part of the driver
> .
> [snip]
> .

I'll remove all the unused/unnecessary defines in the next version.

Thanks!

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
