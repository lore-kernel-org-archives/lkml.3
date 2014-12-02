Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331AbaLBHK0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 02:10:26 -0500
Received: from relay04.alfahosting-server.de ([109.237.142.240]:44504 "EHLO
	relay04.alfahosting-server.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750869AbaLBHKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 02:10:25 -0500
X-Spam-DCC: : 
Date: Tue, 2 Dec 2014 08:10:48 +0100
From: Richard Leitner <dev@g0hl1n.net>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation/email-clients.txt: add info about Claws
 Mail
Message-ID: <20141202081048.357a0953@frodo>
In-Reply-To: <20141201173405.0a291ecb@lwn.net>
References: <20141201230208.4567b6cc@frodo>
	<20141201173405.0a291ecb@lwn.net>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Checker-Version: clamassassin 1.2.4 with ClamAV 0.97.3/19709/Tue Dec  2 06:40:54 2014
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi jon,
thanks for your reply.

On Mon, 1 Dec 2014 17:34:05 -0500
Jonathan Corbet <corbet@lwn.net> wrote:

> Interesting, I've sent an awful lot of patches with claws and I have
> wrapping (a useful feature) enabled.  I can't see it being a problem
> unless you're writing the patch itself in the claws composition
> window...and that would lead to other problems...?

You are right. I had the Auto wrapping disabled because it once messed
up a patch I was editing in the claws composition window. But in
general it works with Auto wrapping enabled. Sorry for that.

Should I change the patch to something like:

To insert a patch use Message->Insert File (CTRL+i) or an external
editor.
If the inserted patch has to be edited in the Claws composition window
Auto wrapping in Configuration->Preferences->Compose->Wrapping should
be disabled.

Or should I resend the patch without any hint to the auto wrapping?

best regards,
richard 

