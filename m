Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296AbaBYOlr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 09:41:47 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:34396 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbaBYOlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 09:41:45 -0500
Date: Tue, 25 Feb 2014 09:41:41 -0500
From: Tejun Heo <tj@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        DCG_UPD_stlinux_kernel@list.st.com, linux-ide@vger.kernel.org
Subject: Re: [PATCH v2 3/3] ahci: st: Add support for ST's SATA IP
Message-ID: <20140225144141.GA26788@htj.dyndns.org>
References: <1393328481-7251-1-git-send-email-lee.jones@linaro.org>
 <1393328481-7251-3-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393328481-7251-3-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 11:41:21AM +0000, Lee Jones wrote:
> Cc: Tejun Heo <tj@kernel.org>
> Cc: linux-ide@vger.kernel.org
> Acked-by: Alexandre Torgue <alexandre.torgue@st.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Applied to libata/for-3.15 w/ missing "\n" added to dev_err() in
st_ahci_suspend().

Thanks.

-- 
tejun
