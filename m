Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391Ab3FMHD1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 03:03:27 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:38495 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab3FMHD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 03:03:26 -0400
MIME-Version: 1.0
In-Reply-To: <20130611153454.6ab17ce44bc4a678b8bf72d4@linux-foundation.org>
References: <1370891880-2644-1-git-send-email-sasha.levin@oracle.com>
	<CAOJsxLGDH2iwznRkP-iwiMZw7Ee3mirhjLvhShrWLHR0qguRxA@mail.gmail.com>
	<51B62F6B.8040308@oracle.com>
	<0000013f3075f90d-735942a8-b4b8-413f-a09e-57d1de0c4974-000000@email.amazonses.com>
	<51B67553.6020205@oracle.com>
	<CAOJsxLH56xqCoDikYYaY_guqCX=S4rcVfDJQ4ki=r-PkNQW9ug@mail.gmail.com>
	<51B72323.8040207@oracle.com>
	<0000013f33cdc631-eadb07d1-ef08-4e2c-a218-1997eb86cde9-000000@email.amazonses.com>
	<51B73F38.6040802@kernel.org>
	<20130611153454.6ab17ce44bc4a678b8bf72d4@linux-foundation.org>
Date: Thu, 13 Jun 2013 10:03:24 +0300
X-Google-Sender-Auth: RdjU1p-_SOUAfuorbYHVg1ZbAb4
Message-ID: <CAOJsxLE=cw8NqmQhbA0AP-c5ckejxuU-1pX4KyHY0J2HN0iTzA@mail.gmail.com>
Subject: Re: [PATCH] slab: prevent warnings when allocating with __GFP_NOWARN
From: Pekka Enberg <penberg@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>, Sasha Levin <sasha.levin@oracle.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 1:34 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> __GFP_NOWARN is frequently used by kernel code to probe for "how big an
> allocation can I get".  That's a bit lame, but it's used on slow paths
> and is pretty simple.

Applied to slab/urgent, thanks guys!
