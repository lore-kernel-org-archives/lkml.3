Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670Ab3EPMi1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 08:38:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13876 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753485Ab3EPMiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 08:38:25 -0400
Date: Thu, 16 May 2013 18:07:46 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        anup.patel@linaro.org
Subject: Re: [PATCH V2 1/3] virtio: console: Add emergency writeonly register
 to config space
Message-ID: <20130516123746.GA4744@amit.redhat.com>
References: <1367842791-30285-1-git-send-email-pranavkumar@linaro.org>
 <1367842791-30285-2-git-send-email-pranavkumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367842791-30285-2-git-send-email-pranavkumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Mon) 06 May 2013 [17:49:49], Pranavkumar Sawargaonkar wrote:
> This patch adds an emerg_wr register (writeonly) in config space
> of virtio console device which can be used for debugging.
> 
> Signed-off-by: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
> Signed-off-by: Anup Patel <anup.patel@linaro.org>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

OK, this change by itself looks harmless.

Acked-by: Amit Shah <amit.shah@redhat.com>

		Amit
