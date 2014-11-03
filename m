Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268AbaKCQrC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 11:47:02 -0500
Received: from tex.lwn.net ([70.33.254.29]:38257 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908AbaKCQq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 11:46:58 -0500
Date: Mon, 3 Nov 2014 11:46:56 -0500
From: Jonathan Corbet <corbet@lwn.net>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CodingStyle: Add a chapter on conditional compilation
Message-ID: <20141103114656.3bf200df@lwn.net>
In-Reply-To: <430ce084b015d22a597ef7e4f6436dadaea7b23d.1414606455.git.josh@joshtriplett.org>
References: <430ce084b015d22a597ef7e4f6436dadaea7b23d.1414606455.git.josh@joshtriplett.org>
Organization: LWN.net
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2014 11:15:17 -0700
Josh Triplett <josh@joshtriplett.org> wrote:

> Document several common practices and conventions regarding conditional
> compilation, most notably the preference for ifdefs in headers rather
> than .c files.

OK, I've picked this one up for my 3.19 docs pull.

Thanks,

jon
