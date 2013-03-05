Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395Ab3CEIwp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 03:52:45 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:45657 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752883Ab3CEIwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 03:52:43 -0500
Message-ID: <1362473477.23194.209.camel@cumari.coelho.fi>
Subject: Re: [PATCH 3/5] wl1251: call pm_runtime_put_sync in
 pm_runtime_get_sync failed case
From: Luciano Coelho <coelho@ti.com>
To: Li Fei <fei.li@intel.com>
CC: <linville@tuxdriver.com>, <wfp5p@virginia.edu>,
        <gregkh@linuxfoundation.org>, <notasas@gmail.com>, <rjw@sisk.pl>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <chuansheng.liu@intel.com>
Date: Tue, 5 Mar 2013 10:51:17 +0200
In-Reply-To: <1362037892.6212.13.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
References: <1362037031.6212.3.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
	 <1362037455.6212.8.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
	 <1362037892.6212.13.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-28 at 15:51 +0800, Li Fei wrote:
> Even in failed case of pm_runtime_get_sync, the usage_count
> is incremented. In order to keep the usage_count with correct
> value and runtime power management to behave correctly, call
> pm_runtime_put(_sync) in such case.
> 
> Signed-off-by Liu Chuansheng <chuansheng.liu@intel.com>
> Signed-off-by: Li Fei <fei.li@intel.com>
> ---

Applied, thanks!

-- 
Luca.

