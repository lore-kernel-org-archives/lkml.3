Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab3H2KcO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 06:32:14 -0400
Received: from multi.imgtec.com ([194.200.65.239]:54325 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753394Ab3H2KcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 06:32:13 -0400
Message-ID: <521F22D3.5070602@imgtec.com>
Date: Thu, 29 Aug 2013 11:30:43 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Tejun Heo <tj@kernel.org>, <akpm@linuxfoundation.org>,
        <linux-arch@vger.kernel.org>, Steven Rostedt <srostedt@redhat.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [gcv v3 19/35] drivers: Replace __get_cpu_var uses
References: <20130828193457.140443630@linux.com> <00000140c6781cfa-5624d7f6-8021-42d1-a6ab-d98d2a20d763-000000@email.amazonses.com>
In-Reply-To: <00000140c6781cfa-5624d7f6-8021-42d1-a6ab-d98d2a20d763-000000@email.amazonses.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_08_29_11_32_05
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/08/13 20:48, Christoph Lameter wrote:
> Signed-off-by: Christoph Lameter <cl@linux.com>

Acked-by: James Hogan <james.hogan@imgtec.com>

Let me know if you want me to take this metag_generic.c and the
arch/metag one through the metag tree.

Cheers
James

