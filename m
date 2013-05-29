Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966919Ab3E2UeC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 16:34:02 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50237 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966083Ab3E2Ud4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 16:33:56 -0400
Date: Wed, 29 May 2013 13:33:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Johan Hovold <jhovold@gmail.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Robert Nelson <Robert.Nelson@digikey.com>
Subject: Re: [PATCH v3 0/5] rtc-at91rm9200: add shadow interrupt mask
Message-Id: <20130529133354.dd181c845ee4e96527483345@linux-foundation.org>
In-Reply-To: <1369298335-24597-1-git-send-email-jhovold@gmail.com>
References: <1364983415-20298-1-git-send-email-jhovold@gmail.com>
	<1369298335-24597-1-git-send-email-jhovold@gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 May 2013 10:38:50 +0200 Johan Hovold <jhovold@gmail.com> wrote:

> This is an update of the shadow-interrupt-mask series against v3.10-rc2.
> 
> I guess we need Atmel to confirm that all sam9x5 SoCs are indeed
> affected. If not, then some probing mechanism as the one Doug suggested
> could be implemented on top of (a subset of) these patches. What do you
> say, Nicolas?
> 
> Note that the first patch (adding a missing OF compile guard) could be
> applied straight away.

At this stage it is unclear to me how to proceed with patches 2-5.
