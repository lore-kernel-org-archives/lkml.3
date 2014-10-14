Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932296AbaJNMZ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 08:25:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49541 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932244AbaJNMZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 08:25:27 -0400
Date: Tue, 14 Oct 2014 08:25:21 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>,
        dm-devel@redhat.com
Subject: Re: [PATCH 2/4] md: add flush_idx support for stacked devices
Message-ID: <20141014122520.GA7243@redhat.com>
References: <1413281035-6483-1-git-send-email-dmonakhov@openvz.org>
 <1413281035-6483-3-git-send-email-dmonakhov@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413281035-6483-3-git-send-email-dmonakhov@openvz.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14 2014 at  6:03am -0400,
Dmitry Monakhov <dmonakhov@openvz.org> wrote:

> For single device mapping it is safe to introduce get_flush_idx conception.
> This cover most common case linear mapping for a single dev.

You really should email the entire patchset rather than forcing the need
to hunt for the remainder of the patches that actually provide context
for this change.
