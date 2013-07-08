Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100Ab3GHNk3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 09:40:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17053 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751430Ab3GHNk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 09:40:28 -0400
Message-ID: <1373290822.7093.1.camel@t520.redhat.com>
Subject: Re: [PATCH] c6x: remove unused parameter in Kconfig
From: Mark Salter <msalter@redhat.com>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: a-jacquiot@ti.com, linux-c6x-dev@linux-c6x.org,
        linux-kernel@vger.kernel.org
Date: Mon, 08 Jul 2013 09:40:22 -0400
In-Reply-To: <1373260191-23158-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1373260191-23158-1-git-send-email-michael.opdenacker@free-electrons.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-08 at 07:09 +0200, Michael Opdenacker wrote:
> This patch proposes to remove the TMS320C6X_CACHES_ON kernel configuration
> parameter defined in arch/c6x/Kconfig, but used nowhere
> in the makefiles and source code.
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> ---

Acked by: Mark Salter <msalter@redhat.com>


