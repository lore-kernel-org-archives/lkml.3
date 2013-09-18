Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751671Ab3IRH2J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 03:28:09 -0400
Received: from eu1sys200aog124.obsmtp.com ([207.126.144.157]:60450 "EHLO
	eu1sys200aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751369Ab3IRH2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 03:28:07 -0400
X-Greylist: delayed 1918 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Sep 2013 03:28:07 EDT
Message-ID: <523949A1.7080600@st.com>
Date: Wed, 18 Sep 2013 07:35:13 +0100
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Reply-To: srinivas.kandagatla@st.com
Organization: STMicroelectronics
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: stuart.menefy@st.com, linux-arm-kernel@lists.infradead.org,
        kernel@stlinux.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: STi: remove unused Kconfig parameters
References: <1379474622-4715-1-git-send-email-michael.opdenacker@free-electrons.com>
In-Reply-To: <1379474622-4715-1-git-send-email-michael.opdenacker@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael.
On 18/09/13 04:23, Michael Opdenacker wrote:
> This patch proposes to remove the 'SOC_STIH415' and 'SOC_STIH416'
> parameters, which are used nowhere else in the source code
> and Makefiles.
> 
> Will they be needed in code that hasn't been submitted yet?
Yes, we will be using it in future patches, for something like reset
controller.
Also I am planning to use in dts/Makefiles so that we can build dtbs for
only selected SOC.

Thanks,
srini


