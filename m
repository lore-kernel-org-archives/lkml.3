Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744Ab3LNAQq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 19:16:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12437 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751656Ab3LNAQo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 19:16:44 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20131213131353.17d49ac4@gandalf.local.home>
References: <20131213131353.17d49ac4@gandalf.local.home> <20131213175350.0c4a95d5@endymion.delvare> <20131213163349.4bc686c0@endymion.delvare> <20131213142627.4014.42860.stgit@warthog.procyon.org.uk> <3708.1386950736@warthog.procyon.org.uk> <18214.1386955613@warthog.procyon.org.uk>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: dhowells@redhat.com, Jean Delvare <khali@linux-fr.org>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wolfram Sang <wolfram@the-dreams.de>
Subject: Re: [PATCH] i2c: Add message transfer tracepoints for I2C and SMBUS
Date: Sat, 14 Dec 2013 00:16:27 +0000
Message-ID: <11338.1386980187@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> wrote:

> Now that you have two tracepoints that are identical, you can use
> DECLARE_EVENT_CLASS() and DEFINE_EVENT_FN(). That is:

They're not identical.  i2c_write() has a data buffer that i2c_read() does
not.

David
