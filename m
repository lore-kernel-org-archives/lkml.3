Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723AbaJBAZd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 20:25:33 -0400
Received: from mail-ie0-f201.google.com ([209.85.223.201]:41792 "EHLO
	mail-ie0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbaJBAZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 20:25:32 -0400
Date: Wed, 1 Oct 2014 17:25:30 -0700
From: Peter Feiner <pfeiner@google.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>, Jamie Liu <jamieliu@google.com>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] mm: softdirty: unmapped addresses between VMAs are
 clean
Message-ID: <20141002002530.GF7019@google.com>
References: <1410391486-9106-1-git-send-email-pfeiner@google.com>
 <1410806438-7496-1-git-send-email-pfeiner@google.com>
 <20140926203326.GA12422@nhori.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140926203326.GA12422@nhori.bos.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 04:33:26PM -0400, Naoya Horiguchi wrote:
> Could you test and merge the following change?

Many apologies for the late reply! Your email was in my spam folder :-( I see
that Andrew has already merged the patch, so we're in good shape!

Thanks for fixing this bug Naoya!
