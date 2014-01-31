Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932756AbaAaTNf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 14:13:35 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:34122 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236AbaAaTNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 14:13:33 -0500
Date: Fri, 31 Jan 2014 11:11:42 -0800
From: Olof Johansson <olof@lixom.net>
To: Kumar Gala <galak@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] Split mach-msm into legacy and mach-qcom
 (multiplatform)
Message-ID: <20140131191142.GB32295@quad.lixom.net>
References: <1391107002-21470-1-git-send-email-galak@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391107002-21470-1-git-send-email-galak@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 30, 2014 at 12:36:38PM -0600, Kumar Gala wrote:
> This is the starts of splitting the Qualcomm MSM platform into legacy support
> that we will not try and convert to multiplatform and multiplatform support.
> These patches are based on the 'CPU enable method based SMP' patches.
> 
> I wanted to get these out for review, will add a few more patches for defconfig
> updates/additions, as well as some additional driver being enabled for ARCH_QCOM.

Series:

Acked-by: Olof Johansson <olof@lixom.net>

See comment on the MAINTAINERS addition; let me know how you prefer to send us
patches. We can apply from mailing lists we just need to know your preference.


-Olof
