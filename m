Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab3AXOrO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 09:47:14 -0500
Received: from mail-vc0-f176.google.com ([209.85.220.176]:64659 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838Ab3AXOrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 09:47:11 -0500
MIME-Version: 1.0
In-Reply-To: <20130124141930.GA14881@gmail.com>
References: <1356434680-10045-1-git-send-email-festevam@gmail.com>
	<CAOMZO5AzJUvrc5LcNyqPbEz0g4U5KZAXrNK8oJUiht=fdyuc5g@mail.gmail.com>
	<20130124141930.GA14881@gmail.com>
Date: Thu, 24 Jan 2013 12:47:11 -0200
Message-ID: <CAOMZO5CC76Md9T=2z3RWi4GrKsUuFcc8VYV1QfmZWF41vnOhVw@mail.gmail.com>
Subject: Re: [PATCH v2] sched: Fix print format for u64
From: Fabio Estevam <festevam@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: mingo@redhat.com, peterz@infradead.org, pjt@google.com,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 12:19 PM, Ingo Molnar <mingo@kernel.org> wrote:

> I suppose - is this patch warning-free both on 64-bit and 32-bit
> systems?

Yes, just confirmed that this patch is warning-free on both 64-bit and
32-bit machines.

Regards,

Fabio Estevam
