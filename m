Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933396Ab3LDTyd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 14:54:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34785 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933067Ab3LDTyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 14:54:14 -0500
Date: Wed, 4 Dec 2013 11:54:12 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/5] tty: serial: Limit msm_serial_hs driver to platforms
 that use it
Message-ID: <20131204195412.GA28909@kroah.com>
References: <1386185952-27259-1-git-send-email-sboyd@codeaurora.org>
 <1386185952-27259-3-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386185952-27259-3-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 11:39:09AM -0800, Stephen Boyd wrote:
> The msm_serial_hs driver uses mach specific dma APIs. This is not
> compatible with the multi-platform ARM effort. Let's only compile
> this driver on MSM devices that are prepared to support it;
> allowing the DT based MSM devices to enter the multi-platform ARM
> build.
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
