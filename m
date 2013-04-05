Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162396Ab3DESRx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 14:17:53 -0400
Received: from mail-vb0-f52.google.com ([209.85.212.52]:40763 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162360Ab3DESRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 14:17:51 -0400
MIME-Version: 1.0
In-Reply-To: <20130405181524.30258.77595.stgit@phlsvslse11.ph.intel.com>
References: <20130405181524.30258.77595.stgit@phlsvslse11.ph.intel.com>
Date: Fri, 5 Apr 2013 11:17:48 -0700
X-Google-Sender-Auth: hyGA9ic3_h9fFseHYa7QkrLN4fQ
Message-ID: <CA+55aFwouGCh6RLuqd=Wf1Tu4+-0EcjXh8y3bxGukhX7eyv5qQ@mail.gmail.com>
Subject: Re: [PATCH v2] firmware,IB/qib: revert firmware file move
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mike Marciniszyn <mike.marciniszyn@intel.com>
Cc: Roland Dreier <roland@purestorage.com>, Dean Luick <dean.luick@intel.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Vinit Abhay Agnihotri <vinit.abhay.agnihotri@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 5, 2013 at 11:15 AM, Mike Marciniszyn
<mike.marciniszyn@intel.com> wrote:
> Commit e2eed58 ("IB/qib: change QLogic to Intel") moved a firmware file
> potentially breaking the ABI.

Please send things like this generated with the "-M" flag so that you
can see it as a rename, instead of a huge add/del patch.

Sure, some people may still use traditional "patch", but catering to
them when it actually hides what the patch does is just not worth it.

               Linus
