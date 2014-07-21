Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057AbaGUMS7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 08:18:59 -0400
Received: from mail-qg0-f52.google.com ([209.85.192.52]:35029 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755024AbaGUMS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 08:18:56 -0400
Date: Mon, 21 Jul 2014 08:18:52 -0400
From: Tejun Heo <tj@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@stlinux.com,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>
Subject: Re: [PATCH 1/1] ahci: st: Provide DT bindings for ST's SATA
 implementation
Message-ID: <20140721121852.GC12921@htj.dyndns.org>
References: <1405931316-12276-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405931316-12276-1-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 09:28:36AM +0100, Lee Jones wrote:
> Cc: devicetree@vger.kernel.org
> Cc: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> Acked-by: Alexandre Torgue <alexandre.torgue@st.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
> 
> Hi Tejun,
> 
> This patch has been on the MLs for a few months now.  It documents
> ST's AHCI driver which was accepted by you and now resides in
> Mainline.

Sorry about that.  Applied to libata/for-3.17.

Thanks.

-- 
tejun
