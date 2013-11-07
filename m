Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517Ab3KGNb0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 08:31:26 -0500
Received: from mail.skyhub.de ([78.46.96.112]:38832 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751367Ab3KGNbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 08:31:22 -0500
Date: Thu, 7 Nov 2013 14:33:29 +0100
From: Borislav Petkov <bp@alien8.de>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Doug Thompson <dougthompson@xmission.com>,
        Robert Richter <rric@kernel.org>, linux-edac@vger.kernel.org
Subject: Re: [PATCH] edac, highbank: remove dependency on ARCH_HIGHBANK
Message-ID: <20131107133329.GJ27116@x1.alien8.de>
References: <1383708352-19527-1-git-send-email-robherring2@gmail.com>
 <20131106142025.GB16072@x1.alien8.de>
 <527A6B08.5020302@gmail.com>
 <20131106165437.GA21870@x1.alien8.de>
 <527A79B5.4070507@gmail.com>
 <20131107122716.GC27116@x1.alien8.de>
 <527B943E.9050603@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <527B943E.9050603@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 07, 2013 at 07:23:10AM -0600, Rob Herring wrote:
> See, we are benefiting already.

You can catch this when building on arm64, i.e. basically one of the
target architectures for which the driver is meant for.

-- 
Regards/Gruss,
Boris.
