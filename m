Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab3KKKsA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 05:48:00 -0500
Received: from mail.skyhub.de ([78.46.96.112]:47381 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752884Ab3KKKrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 05:47:52 -0500
Date: Mon, 11 Nov 2013 11:47:29 +0100
From: Borislav Petkov <bp@alien8.de>
To: Robert Richter <rric@kernel.org>
Cc: Rob Herring <robherring2@gmail.com>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Doug Thompson <dougthompson@xmission.com>, linux-edac@vger.kernel.org
Subject: Re: [PATCH] edac, highbank: remove dependency on ARCH_HIGHBANK
Message-ID: <20131111104729.GB28219@pd.tnic>
References: <20131106142025.GB16072@x1.alien8.de>
 <527A6B08.5020302@gmail.com>
 <20131106165437.GA21870@x1.alien8.de>
 <527A79B5.4070507@gmail.com>
 <20131107122716.GC27116@x1.alien8.de>
 <527B943E.9050603@gmail.com>
 <20131107133329.GJ27116@x1.alien8.de>
 <20131108135918.GO7429@rric.localhost>
 <20131108144700.GB7044@x1.alien8.de>
 <20131111102903.GP7429@rric.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131111102903.GP7429@rric.localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 11:29:03AM +0100, Robert Richter wrote:
> The config option was introduced for this, enable it to be built on
> all archs but have an option to disable it on archs where it is not
> supposed to run on. I rather prefer COMPILE_TEST. Could we agree on
> this?

Sure.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
