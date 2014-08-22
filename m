Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098AbaHVLQj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 07:16:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57178 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753229AbaHVLQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 07:16:37 -0400
Message-ID: <53F72692.5050904@suse.cz>
Date: Fri, 22 Aug 2014 13:16:34 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: "J. German Rivera" <German.Rivera@freescale.com>,
        gregkh@linuxfoundation.org, arnd@arndb.de,
        linux-kernel@vger.kernel.org
CC: stuart.yoder@freescale.com, linuxppc-release@linux.freescale.net
Subject: Re: [RFC PATCH 2/4 v2] drivers/bus: Freescale Management Complex
 (fsl-mc) bus driver
References: <1408496070-6252-1-git-send-email-German.Rivera@freescale.com> <1408496070-6252-3-git-send-email-German.Rivera@freescale.com>
In-Reply-To: <1408496070-6252-3-git-send-email-German.Rivera@freescale.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 20.8.2014 02:54, J. German Rivera napsal(a):
> +	pr_info("MC bus (built " __DATE__ " " __TIME__ ") registered\n");

This won't build with gcc 4.9:

# Prohibit date/time macros, which would make the build non-deterministic
KBUILD_CFLAGS   += $(call cc-option,-Werror=date-time)


Michal
