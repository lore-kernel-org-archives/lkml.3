Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307Ab3A3Xrc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 18:47:32 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:36804 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757237Ab3A3Xr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 18:47:29 -0500
Message-ID: <5109B11C.2010400@suse.cz>
Date: Thu, 31 Jan 2013 00:47:40 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:18.0) Gecko/20121129 Thunderbird/18.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Borislav Petkov <bp@alien8.de>, Bjorn Helgaas <bhelgaas@google.com>,
        x86@kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: Re: Uhhuh. NMI received for unknown reason 2c on CPU 0.
References: <20130129202848.GE25415@pd.tnic> <2240511.0oyl5pIt1j@vostro.rjw.lan> <51099BE2.5090706@suse.cz> <3120802.QvTiDSHyPj@vostro.rjw.lan> <5109A8F1.9040707@suse.cz>
In-Reply-To: <5109A8F1.9040707@suse.cz>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2013 12:12 AM, Jiri Slaby wrote:
> I think I will start with commenting parts of `power' script to see
> exactly which of the power savings cause this.

... NMI watchdog. If I remove it from the script, the problem
disappears. If I try it alone, I have those NMIs.

-- 
js
suse labs
