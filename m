Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935076AbaEaD6K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 23:58:10 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:37716 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932750AbaEaD6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 23:58:08 -0400
Date: Fri, 30 May 2014 20:58:18 -0700
From: Olof Johansson <olof@lixom.net>
To: Kumar Gala <galak@codeaurora.org>
Cc: arm@kernel.org, Kevin Hilman <khilman@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-kernel@vger.kernel.org, David Brown <davidb@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org,
        Andy Gross <agross@codeaurora.org>, gregkh@linuxfoundation.org
Subject: Re: [GIT PULL] qcom driver changes for v3.16-2
Message-ID: <20140531035818.GD14790@quad.lixom.net>
References: <alpine.DEB.2.00.1405301138220.5291@galak-ubuntu.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1405301138220.5291@galak-ubuntu.qualcomm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 11:41:01AM -0500, Kumar Gala wrote:
> The following changes since commit 5d144e36b7c51612922fa05d37ff3a869261cc82:
> 
>   soc: qcom: Add GSBI driver (2014-05-23 11:38:04 -0500)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/galak/linux-qcom.git tags/qcom-drivers-for-3.16-2
> 
> for you to fetch changes up to 31964ffebbb958c6cf289c7c12edd7530d6221b9:
> 
>   tty: serial: msm: Remove direct access to GSBI (2014-05-29 11:06:20 -0500)
> 
> ----------------------------------------------------------------
> Qualcomm ARM Based driver Updates for v3.16-2
> 
> * Updated MSM uart driver to not access GSBI control registers

Ok, merged.


-Olof
