Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261AbaBRXgv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 18:36:51 -0500
Received: from mail-qg0-f41.google.com ([209.85.192.41]:36230 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbaBRXgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 18:36:49 -0500
Date: Tue, 18 Feb 2014 18:36:45 -0500
From: Tejun Heo <tj@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alexandre.torgue@st.com, linux-ide@vger.kernel.org,
        hdegoede@redhat.com
Subject: Re: [PATCH 3/3] ahci: st: Add support for ST's SATA IP
Message-ID: <20140218233645.GP31892@mtj.dyndns.org>
References: <1392641818-23419-1-git-send-email-lee.jones@linaro.org>
 <1392641818-23419-3-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392641818-23419-3-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 12:56:58PM +0000, Lee Jones wrote:
> Cc: Tejun Heo <tj@kernel.org>
> Cc: linux-ide@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Please consider basing it on top of Hans' refactored ahci_platform.

 http://www.spinics.net/lists/linux-ide/msg47628.html

Thanks.

-- 
tejun
