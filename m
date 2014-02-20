Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166AbaBTWqG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 17:46:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22950 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753024AbaBTWqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 17:46:05 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1392929071-16555-8-git-send-email-tj@kernel.org>
References: <1392929071-16555-8-git-send-email-tj@kernel.org> <1392929071-16555-1-git-send-email-tj@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: dhowells@redhat.com, laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org,
        linux-afs@lists.infradead.org
Subject: Re: [PATCH 7/9] afs: don't use PREPARE_WORK
Date: Thu, 20 Feb 2014 22:00:05 +0000
Message-ID: <32161.1392933605@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> wrote:

> PREPARE_[DELAYED_]WORK() are being phased out.  They have few users
> and a nasty surprise in terms of reentrancy guarantee as workqueue
> considers work items to be different if they don't have the same work
> function.

Why so?  Isn't the work item address sufficient to distinguish them?

David
