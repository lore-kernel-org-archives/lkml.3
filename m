Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab3AXPVl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 10:21:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19149 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752384Ab3AXPVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 10:21:38 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1358955044-27407-4-git-send-email-mmarek@suse.cz>
References: <1358955044-27407-4-git-send-email-mmarek@suse.cz> <1358955044-27407-1-git-send-email-mmarek@suse.cz>
To: Michal Marek <mmarek@suse.cz>
Cc: dhowells@redhat.com, rusty@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] MODSIGN: Add -s <signature> option to sign-file
Date: Thu, 24 Jan 2013 15:20:53 +0000
Message-ID: <28810.1359040853@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+die "Can't read private key\n" if !$signature_file && !-r $private_key;
+die "Can't read signature file\n" if $signature_file && !-r $signature_file;

Please bracket the if condition.

David
