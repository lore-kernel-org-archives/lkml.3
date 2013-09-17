Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128Ab3IQWJN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 18:09:13 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55166 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435Ab3IQWJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 18:09:12 -0400
Date: Tue, 17 Sep 2013 23:03:23 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Christian Daudt <csd@broadcom.com>
Cc: Olof Johansson <olof@lixom.net>, Stephen Warren <swarren@nvidia.com>,
        linux-arm-kernel@lists.infradead.org, Chris Ball <cjb@laptop.org>,
        linux-kernel@vger.kernel.org, bcm@fixthebug.org
Subject: Re: [PATCH] ARM: bcm: Add DEBUG_LL console support
Message-ID: <20130917220323.GS12758@n2100.arm.linux.org.uk>
References: <1379455187-5812-1-git-send-email-csd@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379455187-5812-1-git-send-email-csd@broadcom.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 17, 2013 at 02:59:47PM -0700, Christian Daudt wrote:
> This patch adds low level debug uart support to Broadcom
>  mobile based SOCs.
> 
> Signed-off-by: Christian Daudt <csd@broadcom.com>
> Reviewed-by: James King <jamesk@broadcom.com>

Unfortunately, your patch is out of date.

Please have a look at v3.12-rc1's debugging infrastructure.  You should
not need to add any .S file(s) for 8250 based ports, and in fact,
8250_32.S is gone.  It's now all done through Kconfig for these ports.

Thanks.
