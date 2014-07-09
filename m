Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312AbaGIPbg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 11:31:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52447 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755085AbaGIPbd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 11:31:33 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1403620852-16476-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1403620852-16476-1-git-send-email-zohar@linux.vnet.ibm.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, keyrings <keyrings@linux-nfs.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Josh Boyer <jwboyer@redhat.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Subject: Re: [PATCH v6 0/6] ima: extending secure boot certificate chain of trust
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <24143.1404919879.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 8BIT
Date: Wed, 09 Jul 2014 16:31:19 +0100
Message-ID: <24144.1404919879@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Okay, I've merged a number of patchsets together that I want to push for the
next merge window:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=keys-next

I'd like to add yours.  Shall I pull:

	linux-integrity/next-trusted-keys

which is here, I presume:

	http://git.kernel.org/cgit/linux/kernel/git/zohar/linux-integrity.git/

David
