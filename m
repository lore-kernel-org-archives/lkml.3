Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238Ab3GHU6s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 16:58:48 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50998 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753137Ab3GHU6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 16:58:47 -0400
Date: Mon, 8 Jul 2013 22:58:34 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matt Wilson <msw@amazon.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        jeremy@goop.org, xen-devel@lists.xensource.com, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, mingo@redhat.com,
        tglx@linutronix.de
Subject: Re: [Xen-devel] [PATCH] xen: remove unused Kconfig parameter
Message-ID: <20130708205834.GA481@pd.tnic>
References: <1373264904-27053-1-git-send-email-michael.opdenacker@free-electrons.com>
 <20130708192854.GF4927@phenom.dumpdata.com>
 <20130708193457.GA6926@u109add4315675089e695.ant.amazon.com>
 <51DB2134.9040909@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51DB2134.9040909@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 08, 2013 at 01:29:40PM -0700, H. Peter Anvin wrote:
> What. The. Fuck.

This is just marvellous: grub2 has a bunch of scripts in /etc/grub.d
which rely on the presence of kernel config files in /boot or / and
greps them in order to do the menu entries based on the built-in
features it finds in them.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
