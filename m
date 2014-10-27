Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748AbaJ0XGO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 19:06:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41097 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbaJ0XGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 19:06:12 -0400
Date: Mon, 27 Oct 2014 16:06:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Steve Capper <steve.capper@linaro.org>,
        Andrea Arcangeli <aarcange@redhat.com>, benh@kernel.crashing.org,
        mpe@ellerman.id.au, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH V3 1/2] mm: Update generic gup implementation to handle
 hugepage directory
Message-Id: <20141027160612.b7fd0b1cc9d82faeaa674940@linux-foundation.org>
In-Reply-To: <1414233860-7683-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1414233860-7683-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Oct 2014 16:14:19 +0530 "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:

> Update generic gup implementation with powerpc specific details.
> On powerpc at pmd level we can have hugepte, normal pmd pointer
> or a pointer to the hugepage directory.

I grabbed these.  It would be better if they were merged into the powerpc
tree where they'll get more testing than in linux-next alone.

