Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933147Ab3JOQP1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 12:15:27 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:39484 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932437Ab3JOQPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 12:15:23 -0400
MIME-Version: 1.0
In-Reply-To: <20131015092851.GA7908@pd.tnic>
References: <1381473166-29303-1-git-send-email-gong.chen@linux.intel.com>
	<20131011080427.GC18719@pd.tnic>
	<20131014064940.GD12189@gchen.bj.intel.com>
	<20131014105533.GF4009@pd.tnic>
	<20131015040731.GA887@gchen.bj.intel.com>
	<20131015092851.GA7908@pd.tnic>
Date: Tue, 15 Oct 2013 09:15:21 -0700
Message-ID: <CA+8MBbJeSJBDPcomupOuVBrnZNkMTNTXsoZY9yUbXPe9YrTFXg@mail.gmail.com>
Subject: Re: Extended H/W error log driver
From: Tony Luck <tony.luck@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Chen Gong <gong.chen@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-acpi <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 2:28 AM, Borislav Petkov <bp@alien8.de> wrote:
> We can even add a hint for the user like:
>
>         "Above errors have been corrected by the hardware and require no further action."
>
> Btw, this is valid for both dmesg and trace event output.
>
> Because from my experience so far people just scream: "Look, I just had
> an MCE" withot even reading what it says. And this just upsets support
> people for no valid reason at all.

"Like", "+1", "metoo" ... or whatever it is we do on LKML to indicate
we approve.

-Tony
