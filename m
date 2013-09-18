Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398Ab3IRQRU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 12:17:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34745 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751510Ab3IRQRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 12:17:19 -0400
Message-ID: <1379521034.1817.55.camel@deneb.redhat.com>
Subject: Re: [PATCH][RESEND] c6x: remove unused parameter in Kconfig
From: Mark Salter <msalter@redhat.com>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: a-jacquiot@ti.com, linux-c6x-dev@linux-c6x.org,
        linux-kernel@vger.kernel.org
Date: Wed, 18 Sep 2013 12:17:14 -0400
In-Reply-To: <1379388089-4384-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1379388089-4384-1-git-send-email-michael.opdenacker@free-electrons.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-09-17 at 05:21 +0200, Michael Opdenacker wrote:
> This patch proposes to remove the TMS320C6X_CACHES_ON kernel configuration
> parameter defined in arch/c6x/Kconfig, but used nowhere
> in the makefiles and source code.
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> Acked by: Mark Salter <msalter@redhat.com>

Thanks for the reminder. I have added it to the c6x tree now.


