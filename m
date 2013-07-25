Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220Ab3GYQEP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 12:04:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51962 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755778Ab3GYQEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 12:04:13 -0400
Subject: Re: [PATCH 0/7] rapidio: modularize rapidio subsystem
From: Jean Delvare <jdelvare@suse.de>
To: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>, Kumar Gala <galak@kernel.crashing.org>,
        Andre van Herk <andre.van.herk@Prodrive.nl>,
        Micha Nelissen <micha.nelissen@Prodrive.nl>,
        Stef van Os <stef.van.os@Prodrive.nl>
In-Reply-To: <1372447136-5751-1-git-send-email-alexandre.bounine@idt.com>
References: <1372447136-5751-1-git-send-email-alexandre.bounine@idt.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Suse Linux
Date: Thu, 25 Jul 2013 18:03:43 +0200
Message-ID: <1374768223.4604.207.camel@chaos.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexandre,

Le Friday 28 June 2013 à 15:18 -0400, Alexandre Bounine a écrit :
> The following set of patches modifies kernel RapidIO subsystem to enable build
> and use of its components as loadable kernel modules. Combinations of statically
> linked and modular components are also supported.
> (...)

Thanks to this patch set, I was finally able to make all RapidIO support
modular in openSUSE kernels. This is very appreciated, thanks a lot!

-- 
Jean Delvare
Suse L3

