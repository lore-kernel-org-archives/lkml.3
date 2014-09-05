Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097AbaIEUL5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 16:11:57 -0400
Received: from amersmtp1.software.dell.com ([12.106.87.226]:44493 "EHLO
	amersmtp1.software.dell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752867AbaIEULk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 16:11:40 -0400
Message-ID: <540A192D.9020400@tedp.id.au>
Date: Fri, 5 Sep 2014 14:12:29 -0600
From: Ted Percival <ted@tedp.id.au>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.7.0
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Restore missing cpumask_copy() in __x2apic_send_IPI_mask
References: <1409945671-4541-1-git-send-email-ted@tedp.id.au>
In-Reply-To: <1409945671-4541-1-git-send-email-ted@tedp.id.au>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Mlf-Version: 7.4.4.8437
X-Mlf-UniqueId: o201409052011400167016
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2014 01:34 PM, Ted Percival wrote:
> This fixes a hang when initializing SMP CPUs at this point in the boot:

Looks like git-send-email picked up the wrong From address. I'll
resubmit with a consistent email address.
