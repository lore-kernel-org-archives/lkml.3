Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757612AbaDXOVf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 10:21:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60315 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753923AbaDXOVd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 10:21:33 -0400
Message-ID: <1398349285.3010.63.camel@deneb.redhat.com>
Subject: Re: [PATCH v2 06/21] c6x: convert fdt pointers to opaque pointers
From: Mark Salter <msalter@redhat.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Aurelien Jacquiot <a-jacquiot@ti.com>, linux-c6x-dev@linux-c6x.org
Date: Thu, 24 Apr 2014 10:21:25 -0400
In-Reply-To: <1398215901-25609-7-git-send-email-robherring2@gmail.com>
References: <1398215901-25609-1-git-send-email-robherring2@gmail.com>
	 <1398215901-25609-7-git-send-email-robherring2@gmail.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-22 at 20:18 -0500, Rob Herring wrote:
> From: Rob Herring <robh@kernel.org>
> 
> The architecture code does not need to access the internals of the FDT
> blob, so make the pointer to it void *.
> 
> Signed-off-by: Rob Herring <robh@kernel.org>
> Cc: Mark Salter <msalter@redhat.com>
> Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
> Cc: linux-c6x-dev@linux-c6x.org
> ---

Acked-by: Mark Salter <msalter@redhat.com>


