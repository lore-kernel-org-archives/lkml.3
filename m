Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467AbaLBN5l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 08:57:41 -0500
Received: from tex.lwn.net ([70.33.254.29]:59831 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752928AbaLBN5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 08:57:40 -0500
Date: Tue, 2 Dec 2014 08:57:38 -0500
From: Jonathan Corbet <corbet@lwn.net>
To: Richard Leitner <dev@g0hl1n.net>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation/email-clients.txt: add info about Claws
 Mail
Message-ID: <20141202085738.28b7763d@lwn.net>
In-Reply-To: <20141202081048.357a0953@frodo>
References: <20141201230208.4567b6cc@frodo>
	<20141201173405.0a291ecb@lwn.net>
	<20141202081048.357a0953@frodo>
Organization: LWN.net
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Dec 2014 08:10:48 +0100
Richard Leitner <dev@g0hl1n.net> wrote:

> Should I change the patch to something like:
> 
> To insert a patch use Message->Insert File (CTRL+i) or an external
> editor.
> If the inserted patch has to be edited in the Claws composition window
> Auto wrapping in Configuration->Preferences->Compose->Wrapping should
> be disabled.
> 
> Or should I resend the patch without any hint to the auto wrapping?

The former looks good; it's worth a mention in case somebody does decide
to edit their patches on the way out.  Send a new patch (soon for 3.19)
and I'll apply it.

Thanks,

jon
