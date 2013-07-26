Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759973Ab3GZVut (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 17:50:49 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:56759 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547Ab3GZVu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 17:50:26 -0400
Date: Fri, 26 Jul 2013 14:50:23 -0700
From: David Brown <davidb@codeaurora.org>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: gregkh@linuxfoundation.org, grant.likely@linaro.org,
        rob.herring@calxeda.com, rob@landley.net, jslaby@suse.cz,
        devicetree-discuss@lists.ozlabs.org, linux-serial@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, mrana@codeaurora.org,
        sambley@codeaurora.org
Subject: Re: [PATCH v2] tty: serial: Add initial MSM UART High Speed Lite
 driver
Message-ID: <20130726215023.GA1470@codeaurora.org>
References: <1374476749-12763-1-git-send-email-iivanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1374476749-12763-1-git-send-email-iivanov@mm-sol.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 22, 2013 at 10:05:48AM +0300, Ivan T. Ivanov wrote:
>From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
>
>This is a tty driver with console support for Qualcomm's UART
>controllers found in the MSM8974 chipsets. Driver is completely
>based on implementation found in codeaurora.org msm_serial_hs_lite
>with Android dependences removed. Other changes include, moved to
>device managed resources and few cleanups.
>
>Driver functionality was tested in LEGACY_HSUART and BLSP_HSUART mode.

Ivan, do we need this driver with the fixes Stephen Boyd posted that
are supposed to fix the problems with the existing msm_serial.c
driver?  If a single driver can correctly support both devices, that
seems like a better solution to me.

David

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
