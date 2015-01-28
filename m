Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505AbbA1ULp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:11:45 -0500
Received: from tex.lwn.net ([70.33.254.29]:35189 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254AbbA1UKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:10:50 -0500
Date: Wed, 28 Jan 2015 12:12:07 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Jiri Kosina <jkosina@suse.cz>
Cc: David Howells <dhowells@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] MODSIGN: /proc/keys is not unconditionally available
Message-ID: <20150128121207.59254055@lwn.net>
In-Reply-To: <alpine.LNX.2.00.1501131555510.4162@pobox.suse.cz>
References: <alpine.LNX.2.00.1501131555510.4162@pobox.suse.cz>
Organization: LWN.net
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jan 2015 15:57:10 +0100 (CET)
Jiri Kosina <jkosina@suse.cz> wrote:

> Documentation/module-signing.txt file is referring to /proc/keys file in 
> order to view all keys contained in the kernel's keyring. That file is not 
> universally avialble when CONFIG_KEYS is enabled, which is confusing. The 
> fact that the option needed for this procfs interface to exist contains 
> "_DEBUG_" in its name makes it even more confusing. Document this fact.

Applied to the docs tree, thanks.

jon
