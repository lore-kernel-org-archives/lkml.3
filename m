Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936787Ab3DJPQp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 11:16:45 -0400
Received: from gate.crashing.org ([63.228.1.57]:53236 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934984Ab3DJPQo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 11:16:44 -0400
Subject: Re: [PATCH] powerpc: remove "config MPC10X_OPENPIC"
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1365449711.1830.130.camel@x61.thuisdomein>
Date: Wed, 10 Apr 2013 10:16:31 -0500
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <D9A862AE-0B1F-45F0-AA27-2A13C49E6774@kernel.crashing.org>
References: <1365449711.1830.130.camel@x61.thuisdomein>
To: Paul Bolle <pebolle@tiscali.nl>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 8, 2013, at 2:35 PM, Paul Bolle wrote:

> The last users of Kconfig symbol MPC10X_OPENPIC were removed in v2.6.27.
> Its Kconfig entry can be removed now.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Untested.
> 
> arch/powerpc/platforms/embedded6xx/Kconfig | 5 -----
> 1 file changed, 5 deletions(-)

applied to next

- k
