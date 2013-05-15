Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759555Ab3EOQOP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 12:14:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30727 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759519Ab3EOQOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 12:14:14 -0400
Date: Wed, 15 May 2013 18:10:45 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, akpm@linux-foundation.org,
        Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 17/21] Percpu tag allocator
Message-ID: <20130515161045.GA27213@redhat.com>
References: <1368494338-7069-1-git-send-email-koverstreet@google.com> <1368494338-7069-18-git-send-email-koverstreet@google.com> <20130514134859.GA17587@redhat.com> <20130515092543.GE16164@moria.home.lan> <20130515154121.GA21932@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130515154121.GA21932@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Damn, sorry for extra noise, I forgot to ask this twice...

And what about cpu_down()? Perhaps tag_pool should do move_tags()
on CPU_DEAD?

Or at least it should be documented that the dead cpu can lose up
to 2 * watermark entries.

Oleg.

