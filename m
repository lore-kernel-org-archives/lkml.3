Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691Ab3IQMVF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 08:21:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15651 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970Ab3IQMVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 08:21:03 -0400
Message-ID: <1379419218.1817.0.camel@deneb.redhat.com>
Subject: Re: [PATCH 13/28] c6x: use early_init_dt_scan
From: Mark Salter <msalter@redhat.com>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Aurelien Jacquiot <a-jacquiot@ti.com>, linux-c6x-dev@linux-c6x.org
Date: Tue, 17 Sep 2013 08:00:18 -0400
In-Reply-To: <1379372965-22359-14-git-send-email-robherring2@gmail.com>
References: <1379372965-22359-1-git-send-email-robherring2@gmail.com>
	 <1379372965-22359-14-git-send-email-robherring2@gmail.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-16 at 18:09 -0500, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> Convert c6x to use new early_init_dt_scan function.
> 
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> Cc: Mark Salter <msalter@redhat.com>
> Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
> Cc: linux-c6x-dev@linux-c6x.org
> ---
>  arch/c6x/kernel/devicetree.c | 19 -------------------
>  arch/c6x/kernel/setup.c      |  2 +-
>  2 files changed, 1 insertion(+), 20 deletions(-)

Acked-by: Mark Salter <msalter@redhat.com>


