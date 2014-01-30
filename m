Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552AbaA3WfJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 17:35:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43224 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374AbaA3WfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 17:35:06 -0500
Date: Thu, 30 Jan 2014 14:36:19 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Kumar Gala <galak@codeaurora.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 4/4] tty: serial: msm: Enable building msm_serial for
 ARCH_QCOM
Message-ID: <20140130223619.GB4046@kroah.com>
References: <1391107002-21470-1-git-send-email-galak@codeaurora.org>
 <1391107002-21470-5-git-send-email-galak@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391107002-21470-5-git-send-email-galak@codeaurora.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 30, 2014 at 12:36:42PM -0600, Kumar Gala wrote:
> We've split Qualcomm MSM support into legacy and multiplatform.  So add
> the ability to build the serial driver on the newer ARCH_QCOM
> multiplatform.
> 
> Signed-off-by: Kumar Gala <galak@codeaurora.org>
> ---
> Greg,
> 
> If we can get an ack on this, will probably go via the arm-soc tree to keep
> the patchset together.

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
