Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab3AXPMJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 10:12:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754748Ab3AXPMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 10:12:06 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1358955044-27407-2-git-send-email-mmarek@suse.cz>
References: <1358955044-27407-2-git-send-email-mmarek@suse.cz> <1358955044-27407-1-git-send-email-mmarek@suse.cz>
To: Michal Marek <mmarek@suse.cz>
Cc: dhowells@redhat.com, rusty@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] MODSIGN: Simplify Makefile with a Kconfig helper
Date: Thu, 24 Jan 2013 15:11:20 +0000
Message-ID: <28583.1359040280@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Marek <mmarek@suse.cz> wrote:

> Signed-off-by: Michal Marek <mmarek@suse.cz>

Add a check into the script to make sure that CONFIG_MODULE_SIG_HASH is
actually set to something, and then you can add "Acked-by: David Howells
<dhowells@redhat.com>".

David
