Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248AbaCFNjI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 08:39:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15315 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033AbaCFNjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 08:39:06 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20140306131729.GB10657@katana>
References: <20140306131729.GB10657@katana> <11165.1393507178@warthog.procyon.org.uk> <20140218205418.GH18768@katana> <20140109214954.25590.73057.stgit@warthog.procyon.org.uk> <20140109215002.25590.51609.stgit@warthog.procyon.org.uk> <19542.1394111635@warthog.procyon.org.uk>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: dhowells@redhat.com, wolfram@the-dreams.de, khali@linux-fr.org,
        linux-i2c@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] i2c: Add message transfer tracepoints for SMBUS
Date: Thu, 06 Mar 2014 13:38:49 +0000
Message-ID: <29426.1394113129@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wolfram Sang <wsa@the-dreams.de> wrote:

> Yes, that's good, too!

I've posted my current patches.  I've put address before flags and increased
the address field to 3 hex chars and the flags to four.  I've made it
interpolate dashes to indicate the byte divisions in the data dump.

I'll follow up with a separate patch to turn the flags into a more readable
format.

David
