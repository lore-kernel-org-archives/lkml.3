Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185AbbA0AvP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 19:51:15 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:45913 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755398AbbA0AvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 19:51:13 -0500
Message-ID: <54C6E0FF.9000103@codeaurora.org>
Date: Mon, 26 Jan 2015 16:51:11 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Andy Gross <agross@codeaurora.org>, Kumar Gala <galak@codeaurora.org>
CC: David Brown <davidb@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: update Qualcomm support entry
References: <1421901564-8854-1-git-send-email-agross@codeaurora.org>
In-Reply-To: <1421901564-8854-1-git-send-email-agross@codeaurora.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/15 20:39, Andy Gross wrote:
> Added myself as a co-maintainer.  Updated the files to include the Qualcomm SoC
> directory.  Added linux-soc mailing list.
>
> Signed-off-by: Andy Gross <agross@codeaurora.org>
> ---
>  MAINTAINERS |    3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 93409ad..2af6e23 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1284,9 +1284,12 @@ S:	Maintained
>  ARM/QUALCOMM SUPPORT
>  M:	Kumar Gala <galak@codeaurora.org>
>  M:	David Brown <davidb@codeaurora.org>
> +M:	Andy Gross <agross@codeaurora.org>
>  L:	linux-arm-msm@vger.kernel.org
> +L:	linux-soc@vger.kernel.org

Should this be here? I'd think we would want this on some more top-level
drivers/soc/ entry so that mach-qcom changes don't go to the linux-soc
list when they're not relevant to linux-soc.

>  S:	Maintained
>  F:	arch/arm/mach-qcom/
> +F:	drivers/soc/qcom
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/galak/linux-qcom.git
>  
>  ARM/RADISYS ENP2611 MACHINE SUPPORT


-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project

