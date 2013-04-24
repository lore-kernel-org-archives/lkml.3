Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315Ab3DXH01 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 03:26:27 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:60349 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653Ab3DXH00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 03:26:26 -0400
MIME-Version: 1.0
In-Reply-To: <1014891011.990074.1366727496599.JavaMail.root@redhat.com>
References: <1081382531.982691.1366726661820.JavaMail.root@redhat.com>
	<1014891011.990074.1366727496599.JavaMail.root@redhat.com>
Date: Wed, 24 Apr 2013 10:26:24 +0300
X-Google-Sender-Auth: CWS2AK3KBb4PbpN505LsgZihCkc
Message-ID: <CAOJsxLHRskQ81ouGVTqqQpOK3ZQDf6fpw5UYDFi7MY1ij=kmfg@mail.gmail.com>
Subject: Re: [Patch v2] mm: slab: Verify the nodeid passed to ____cache_alloc_node
From: Pekka Enberg <penberg@kernel.org>
To: Aaron Tomlin <atomlin@redhat.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <cl@linux.com>,
        Rik <riel@redhat.com>, Rafael Aquini <aquini@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 5:31 PM, Aaron Tomlin <atomlin@redhat.com> wrote:
> This patch is in response to BZ#42967 [1].
> Using VM_BUG_ON so it's used only when CONFIG_DEBUG_VM is set,
> given that ____cache_alloc_node() is a hot code path.

The patch is pretty badly mangled and does not apply with 'git am'.
Please resend with updated ACKs.

                        Pekka
