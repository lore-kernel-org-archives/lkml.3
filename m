Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998Ab3AQVQy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 16:16:54 -0500
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:50604 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752824Ab3AQVQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 16:16:53 -0500
Date: Thu, 17 Jan 2013 21:16:51 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Steven Rostedt <rostedt@goodmis.org>
cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>
Subject: Re: slob: Check for NULL pointer before calling ctor()
In-Reply-To: <1358442365.23211.17.camel@gandalf.local.home>
Message-ID: <0000013c4a5f15b5-44e75748-33a6-46b1-94f7-b29e5a15e162-000000@email.amazonses.com>
References: <1358442365.23211.17.camel@gandalf.local.home>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jan 2013, Steven Rostedt wrote:

> The solution is to only call the ctor() method if allocation succeeded.

Acked-by: Christoph Lameter <cl@linux.com>
