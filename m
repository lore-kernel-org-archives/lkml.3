Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789AbaHMSyb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 14:54:31 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:47285 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbaHMSya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 14:54:30 -0400
MIME-Version: 1.0
In-Reply-To: <1407797053-12544-1-git-send-email-gregory.0xf0@gmail.com>
References: <1407797053-12544-1-git-send-email-gregory.0xf0@gmail.com>
From: Gregory Fong <gregory.0xf0@gmail.com>
Date: Wed, 13 Aug 2014 11:53:59 -0700
Message-ID: <CADtm3G5EN3juZ8=DaPLD_8vYN+-bWFq92=pzghWpahsq=-JiSA@mail.gmail.com>
Subject: Re: [PATCH] ARM: Explain workaround for faulty ISAR0 register on B15
To: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Cc: Russell King <linux@arm.linux.org.uk>, Will Deacon <will.deacon@arm.com>,
        Matt Porter <mporter@linaro.org>, Christian Daudt <bcm@fixthebug.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Brian Norris <computersforpeace@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Marc Carino <marc.ceeeee@gmail.com>,
        Kevin Cernekee <cernekee@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Gregory Fong <gregory.0xf0@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 3:44 PM, Gregory Fong <gregory.0xf0@gmail.com> wrote:
> The Brahma-B15 CPU design, like Krait, incorrectly indicates that it
> only supports UDIV and SDIV instructions in Thumb mode when it
> actually supports them in ARM and Thumb mode.  This is apparently
> because it follows the DDI0406B ARM ARM which has two values for the
> divide instruction field, instead of the DDI0406C ARM ARM which has
> three values.

NAK myself here. Brian Norris pointed out that this is incorrect, and
he'll send a follow-up patch to remove the forced hwcaps.  Sorry for
the noise.

Regards,
Gregory
