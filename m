Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758319Ab3HMN5z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 09:57:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15271 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756745Ab3HMN5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 09:57:53 -0400
Message-ID: <1376402247.27484.19.camel@t520.redhat.com>
Subject: Re: [PATCH 09/16] Renames in handle_cmdline_files() to complete
 generalization.
From: Mark Salter <msalter@redhat.com>
To: Roy Franz <roy.franz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, matt.fleming@intel.com,
        linux@arm.linux.org.uk, leif.lindholm@linaro.org, dave.martin@arm.com
Date: Tue, 13 Aug 2013 09:57:27 -0400
In-Reply-To: <1376090777-20090-10-git-send-email-roy.franz@linaro.org>
References: <1376090777-20090-1-git-send-email-roy.franz@linaro.org>
	 <1376090777-20090-10-git-send-email-roy.franz@linaro.org>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-08-09 at 16:26 -0700, Roy Franz wrote:
> Rename variables to be not initrd specific, as now the function
> loads arbitrary files.
> 
> Signed-off-by: Roy Franz <roy.franz@linaro.org>
> ---

Tested on arm64.

Acked-by: Mark Salter <msalter@redhat.com>


