Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964841Ab3CZPCS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:02:18 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:52946 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964796Ab3CZPCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:02:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH v2 2/4] dw_dmac: rename DT related methods to reflect their belonging
Date: Tue, 26 Mar 2013 15:02:09 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-13-generic; KDE/4.3.2; x86_64; ; )
Cc: Vinod Koul <vinod.koul@intel.com>, Viresh Kumar <viresh.kumar@linaro.org>,
        linux-kernel@vger.kernel.org, "spear-devel" <spear-devel@list.st.com>
References: <1364309637-25860-1-git-send-email-andriy.shevchenko@linux.intel.com> <1364309637-25860-3-git-send-email-andriy.shevchenko@linux.intel.com>
In-Reply-To: <1364309637-25860-3-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201303261502.09594.arnd@arndb.de>
X-Provags-ID: V02:K0:xc+wPBuyIjdsz3AiYWV7PRXsCxeG0FSQUJcO6s6hr1N
 SgI+Uy6+xLn4CokGozAKAltgUIXM++/wExC1Kf1RWItawJHyC1
 DxDoDiZabk5Dvlg1jT35BnXE+2d8UdVT+Unlj+MD9MIpdP8wg5
 wX7TKk9JzeV1qzVSc7cTAtwTrbmotRFmBdGDV1QGm1erIH3X/x
 stqDlFeFoUu3w1m9rIy7uT1nG0C3Qv+ia5eo19h5ZWXzrvP3RM
 72uuW8t2j72LznBP+gBMEEh3zCgmIscRzaA+rH0EREhyVXfPZy
 Kc2Y12DL8pEhihdIVYmQv6dxcIbECLXAyOKzy+cw5772IXtPS7
 Ysfd6ualKyYAu/ErLp5E=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 March 2013, Andy Shevchenko wrote:
> Since we will have not only DT cases in future let's rename DT related methods
> to reflect their belonging.
> 
> The rename was done as follows:
> 	struct dw_dma_filter_args	-> struct dw_dma_of_filter_args
> 	dw_dma_generic_filter()		-> dw_dma_of_filter()
> 	dw_dma_xlate()			-> dw_dma_of_xlate()
> 	dw_dma_id_table			-> dw_dma_of_id_table
> 
> There is no functional change.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>
