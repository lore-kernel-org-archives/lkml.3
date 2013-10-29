Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756449Ab3J2SQ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:16:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25505 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756399Ab3J2SQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:16:22 -0400
Message-ID: <1383070572.1768.139.camel@deneb.redhat.com>
Subject: Re: [PATCH] c6x: remove unused COMMON_CLKDEV Kconfig parameter
From: Mark Salter <msalter@redhat.com>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: a-jacquiot@ti.com, linux-c6x-dev@linux-c6x.org,
        linux-kernel@vger.kernel.org
Date: Tue, 29 Oct 2013 14:16:12 -0400
In-Reply-To: <1382877784-5020-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1382877784-5020-1-git-send-email-michael.opdenacker@free-electrons.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-10-27 at 13:43 +0100, Michael Opdenacker wrote:
> This removes the COMMON_CLKDEV kernel configuration
> parameter defined in arch/c6x/Kconfig, but used nowhere
> in the makefiles and source code.
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> ---

Thanks. I'll add this to the c6x tree.


