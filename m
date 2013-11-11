Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab3KKK3N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 05:29:13 -0500
Received: from mail-bk0-f41.google.com ([209.85.214.41]:63525 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993Ab3KKK3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 05:29:10 -0500
Date: Mon, 11 Nov 2013 11:29:03 +0100
From: Robert Richter <rric@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Rob Herring <robherring2@gmail.com>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Doug Thompson <dougthompson@xmission.com>, linux-edac@vger.kernel.org
Subject: Re: [PATCH] edac, highbank: remove dependency on ARCH_HIGHBANK
Message-ID: <20131111102903.GP7429@rric.localhost>
References: <1383708352-19527-1-git-send-email-robherring2@gmail.com>
 <20131106142025.GB16072@x1.alien8.de>
 <527A6B08.5020302@gmail.com>
 <20131106165437.GA21870@x1.alien8.de>
 <527A79B5.4070507@gmail.com>
 <20131107122716.GC27116@x1.alien8.de>
 <527B943E.9050603@gmail.com>
 <20131107133329.GJ27116@x1.alien8.de>
 <20131108135918.GO7429@rric.localhost>
 <20131108144700.GB7044@x1.alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131108144700.GB7044@x1.alien8.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08.11.13 15:47:21, Borislav Petkov wrote:
> >  depends on EDAC_MM_EDAC && (ARCH_MULTI_V7 || ARM64 || COMPILE_TEST)
> > 
> > This should enable it with allmodconfig.
> 
> You could do this but the first is already coverage enough IMO and, as I
> said previously, compiling this thing on other architectures could raise
> bugs/issues which are not necessarily such on arm/arm64, for example.

The config option was introduced for this, enable it to be built on
all archs but have an option to disable it on archs where it is not
supposed to run on. I rather prefer COMPILE_TEST. Could we agree on
this?

Thanks,

-Robert
