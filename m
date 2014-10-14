Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050AbaJNIpd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 04:45:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47917 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752174AbaJNIpb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 04:45:31 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <54297DF9.5080003@codethink.co.uk>
References: <54297DF9.5080003@codethink.co.uk> <1410944200-24288-1-git-send-email-rob.jones@codethink.co.uk>
To: Rob Jones <rob.jones@codethink.co.uk>
Cc: dhowells@redhat.com, linux-cachefs@redhat.com,
        linux-kernel@vger.kernel.org, linux-kernel@codethink.co.uk
Subject: Re: [PATCH] fs/fscache/object-list.c: use __seq_open_private()
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8324.1413276321.1@warthog.procyon.org.uk>
Date: Tue, 14 Oct 2014 09:45:21 +0100
Message-ID: <8325.1413276321@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Jones <rob.jones@codethink.co.uk> wrote:

> I submitted the patch below on 17th September but have had no feedback.

It is now upstream.

David
