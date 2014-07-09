Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756448AbaGIQlJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 12:41:09 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:58066 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755722AbaGIQlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 12:41:06 -0400
Message-ID: <1404924054.14643.36.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH v6 0/6] ima: extending secure boot certificate chain of
 trust
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: keyrings <keyrings@linux-nfs.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Josh Boyer <jwboyer@redhat.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Date: Wed, 09 Jul 2014 12:40:54 -0400
In-Reply-To: <24144.1404919879@warthog.procyon.org.uk>
References: <1403620852-16476-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <24144.1404919879@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070916-3532-0000-0000-0000030657C6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-09 at 16:31 +0100, David Howells wrote: 
> Okay, I've merged a number of patchsets together that I want to push for the
> next merge window:
> 
> 	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=keys-next
> 
> I'd like to add yours.  Shall I pull:
> 
> 	linux-integrity/next-trusted-keys
> 
> which is here, I presume:
> 
> 	http://git.kernel.org/cgit/linux/kernel/git/zohar/linux-integrity.git/
> 

Yes, that's fine.  My concern, however, is that the trusted keyring
patches are independent of the other patches being upstreamed and should
be upstreamed regardless of the other patches.

Mimi

