Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974Ab3KNSBa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 13:01:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47904 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754829Ab3KNSBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 13:01:22 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <3184360.WhYjmYFIyN@cmlinux10.ih.lucent.com>
References: <3184360.WhYjmYFIyN@cmlinux10.ih.lucent.com>
To: James Solner <solner@alcatel-lucent.com>
Cc: dhowells@redhat.com, Josh Boyer <jwboyer@fedoraproject.org>,
        Randy Dunlap <rdunlap@infradead.org>, rusty@rustcorp.com.au,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] Add Documentation/module-signing.txt file
Date: Thu, 14 Nov 2013 18:00:51 +0000
Message-ID: <29909.1384452051@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Solner <solner@alcatel-lucent.com> wrote:

> This patch adds the Documentation/module-signing.txt file that is
> currently missing from the Documentation directory. The init/Kconfig
> file references the Documentation/module-signing.txt file to explain
> how kernel module signing works. This patch supplies this documentation. 
> 
> The initial version of this patch provided old documentation
> that was a mixture of the old RHEL style GPG signing. 
> 
> Version 1: Updated the documentation to described the current
>            implementation using x509 certificate signing. 
> 
> Version 2: fixes grammar/spelling mistakes and removes
>            trailing whitespaces. 
> 
> Version 3, fixes grammar/spelling mistakes. 
> 
> Version 4: Include updates from David Howells and fixes for
>            spelling mistakes.            
> 
> Signed-off-by: James Solner <solner@alcatel-lucent.com>

Signed-off-by: David Howells <dhowells@redhat.com>
