Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676Ab3JWMkD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 08:40:03 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:41375 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386Ab3JWMkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 08:40:01 -0400
Message-ID: <1382531997.14960.8.camel@mbp>
Subject: Re: [RFC PATCH] arm64: Add arch support for PCI
From: Catalin Marinas <catalin.marinas@arm.com>
To: Tanmay Inamdar <tinamdar@apm.com>
Cc: Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 23 Oct 2013 13:39:57 +0100
In-Reply-To: <1382529163-31968-1-git-send-email-tinamdar@apm.com>
References: <1382529163-31968-1-git-send-email-tinamdar@apm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tanmay,

On Wed, 2013-10-23 at 12:52 +0100, Tanmay Inamdar wrote:
> This patch adds the PCI arch support in arm64 required by PCI
> midlayer. The PCI support is based on support in 32bit arm arch.

We had a discussion yesterday at the ARM mini-summit in Edinburgh about
PCI(e) support on ARMv8. Rather than creating yet another
implementation, there is a lot of code in there which is not arch
specific and should rather be generalised. There are still some debates
around whether to make the powerpc one generic (and it seems to have
some advantages in terms of DT handling) or making parts of the AArch32
implementation generic. ARM started looking into this but we don't yet
have code to share.

Catalin

