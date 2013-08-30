Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab3H3MpP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 08:45:15 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:60065 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446Ab3H3MpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 08:45:13 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 01/16] Move common EFI stub code from x86 arch code to common location
To: Mark Salter <msalter@redhat.com>, Roy Franz <roy.franz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, matt.fleming@intel.com,
        linux@arm.linux.org.uk, leif.lindholm@linaro.org, dave.martin@arm.com
In-Reply-To: <1376402180.27484.12.camel@t520.redhat.com>
References: <1376090777-20090-1-git-send-email-roy.franz@linaro.org> <1376090777-20090-2-git-send-email-roy.franz@linaro.org> <1376402180.27484.12.camel@t520.redhat.com>
Date: Fri, 30 Aug 2013 13:45:18 +0100
Message-Id: <20130830124518.68BBA3E102A@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Aug 2013 09:56:20 -0400, Mark Salter <msalter@redhat.com> wrote:
> On Fri, 2013-08-09 at 16:26 -0700, Roy Franz wrote:
> > No code changes made, just moving functions from x86 arch directory
> > to common location.
> > Code is shared using #include, similar to how decompression code
> > is shared among architectures.
> > 
> > Signed-off-by: Roy Franz <roy.franz@linaro.org>
> > ---
> 
> Tested on arm64.
> 
> Acked-by: Mark Salter <msalter@redhat.com>

Looks okay to me. I'm not a big fan of #including .c files, but I'm okay
with it as-is for the time being. It can be revisited later to
investigate a clean way to compile these functions as a separate .o file.

Reviewed-by: Grant Likely <grant.likely@linaro.org>

g.
