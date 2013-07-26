Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760283Ab3GZU72 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 16:59:28 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:53340 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760067Ab3GZU7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:59:24 -0400
Date: Fri, 26 Jul 2013 16:59:19 -0400 (EDT)
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: Sekhar Nori <nsekhar@ti.com>
Cc: davinci-linux-open-source@linux.davincidsp.com,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@savoirfairelinux.com
Message-ID: <55770703.973667.1374872359591.JavaMail.root@mail>
In-Reply-To: <51F0F377.1060204@ti.com>
Subject: Re: [RFC] ARM: davinci: da850: add a few pinmux definitions
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 7.1.4_GA_2555 (ZimbraWebClient - GC28 (Linux)/7.1.4_GA_2555)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sekhar,

You wrote:
> Why do you need to add these definitions? If it is for a new platform
> you are working on, then it should be supported using DT, in which
> case
> we use the pinctrl-single driver and define the muxing needed in
> .dts/.dtsi files.

Ok, good to know.

Thanks,
Vivien
