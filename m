Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757862AbaGQT5F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 15:57:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754156AbaGQT5C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 15:57:02 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <7afa0a5a9343ddb354478536bd9dc670057fbebe.1405094060.git.d.kasatkin@samsung.com>
References: <7afa0a5a9343ddb354478536bd9dc670057fbebe.1405094060.git.d.kasatkin@samsung.com> <cover.1405094060.git.d.kasatkin@samsung.com> <cover.1405094060.git.d.kasatkin@samsung.com>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: dhowells@redhat.com, zohar@linux.vnet.ibm.com,
        linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmitry.kasatkin@gmail.com
Subject: Re: [PATCH 2/2] digsig: make crypto builtin if digsig selected as builtin
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <13186.1405627010.1@warthog.procyon.org.uk>
Date: Thu, 17 Jul 2014 20:56:50 +0100
Message-ID: <13187.1405627010@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Kasatkin <d.kasatkin@samsung.com> wrote:

> When SIGNATURE=y but depends on CRYPTO=m, it selects MPILIB as module
> producing build break. This patch makes digsig to select crypto for
> correcting dependency.

I'll apply this one.

David
