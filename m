Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326Ab3IYLzM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 07:55:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42478 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754684Ab3IYLzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 07:55:11 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1379340294-13562-1-git-send-email-antonio.alecrim@gmail.com>
References: <1379340294-13562-1-git-send-email-antonio.alecrim@gmail.com>
To: Antonio Alecrim Jr <antonio.alecrim@gmail.com>
Cc: dhowells@redhat.com, Rusty Russell <rusty@rustcorp.com.au>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] X.509: remove possible code fragility: enumeration values not handled
Date: Wed, 25 Sep 2013 12:55:04 +0100
Message-ID: <997.1380110104@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Imported.  I wonder if it would be better to abort, though.

David
