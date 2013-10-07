Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab3JGUMt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 16:12:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30937 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751234Ab3JGUMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 16:12:47 -0400
Message-ID: <1381176749.17503.62.camel@deneb.redhat.com>
Subject: Re: [PATCH v2 01/29] c6x: use boot_command_line instead of private
 c6x_command_line
From: Mark Salter <msalter@redhat.com>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Aurelien Jacquiot <a-jacquiot@ti.com>, linux-c6x-dev@linux-c6x.org
Date: Mon, 07 Oct 2013 16:12:29 -0400
In-Reply-To: <1381163377-21044-2-git-send-email-robherring2@gmail.com>
References: <1381163377-21044-1-git-send-email-robherring2@gmail.com>
	 <1381163377-21044-2-git-send-email-robherring2@gmail.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-10-07 at 11:29 -0500, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> Save some pointless copying of the kernel command line and just use
> boot_command_line instead.
> 
> Also remove default_command_line as it is not referenced anywhere, and
> the DT code already handles the default command line.
> 
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> Cc: Mark Salter <msalter@redhat.com>
> Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
> Cc: linux-c6x-dev@linux-c6x.org
> Reviewed-by: Grant Likely <grant.likely@linaro.org>
> ---
Tested and
Acked-by: Mark Salter <msalter@redhat.com>


