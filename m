Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab3AaAsr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 19:48:47 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:34893 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751515Ab3AaAsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 19:48:45 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Borislav Petkov <bp@alien8.de>, Bjorn Helgaas <bhelgaas@google.com>,
        x86@kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: Re: Uhhuh. NMI received for unknown reason 2c on CPU 0.
Date: Thu, 31 Jan 2013 01:54:56 +0100
Message-ID: <5170962.qHnbnlVDfx@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc5; KDE/4.9.5; x86_64; ; )
In-Reply-To: <5109B11C.2010400@suse.cz>
References: <20130129202848.GE25415@pd.tnic> <5109A8F1.9040707@suse.cz> <5109B11C.2010400@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 31, 2013 12:47:40 AM Jiri Slaby wrote:
> On 01/31/2013 12:12 AM, Jiri Slaby wrote:
> > I think I will start with commenting parts of `power' script to see
> > exactly which of the power savings cause this.
> 
> ... NMI watchdog. If I remove it from the script, the problem
> disappears. If I try it alone, I have those NMIs.

Well, beats me. :-(

I suspect that it doesn't quiesce itself sufficiently before image restoration
and we get some crosstalk between the boot kernel and the image kernel.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
