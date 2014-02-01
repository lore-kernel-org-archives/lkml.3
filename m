Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658AbaBAS4A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 13:56:00 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:58827 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753770AbaBASz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 13:55:59 -0500
Date: Sat, 1 Feb 2014 19:55:53 +0100
From: Christoph Fritz <chf.fritz@googlemail.com>
To: Tero Kristo <t-kristo@ti.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-kernel@vger.kernel.org, pali.rohar@gmail.com, pavel@ucw.cz,
        Nishanth Menon <nm@ti.com>
Subject: Re: OMAP: clock DT conversion issues with omap36xx
Message-ID: <20140201185553.GB7125@mars>
References: <52E697C0.6000202@gmail.com>
 <1390848104.4936.62.camel@mars>
 <52E772A3.4090401@ti.com>
 <1390901735.2963.8.camel@lovely>
 <52E77D03.8090001@ti.com>
 <52E7B361.2030601@ti.com>
 <1390928565.4904.88.camel@mars>
 <1390994505.5023.32.camel@mars>
 <52E916BC.5040906@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52E916BC.5040906@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 29, 2014 at 04:57:00PM +0200, Tero Kristo wrote:
> 
> Hmm, well, the omap96m_alwon_fck rate is still wrong. Try adding
> ti,min-div = <2>; and ti,max-div = <4>; to properties of the clock
> node.

Hmm, doesn't change anything here.

Thanks
  -- Christoph
