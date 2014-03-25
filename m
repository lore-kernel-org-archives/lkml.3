Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265AbaCYSHI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 14:07:08 -0400
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:59549 "EHLO
	qmta02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752382AbaCYSHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 14:07:05 -0400
Date: Tue, 25 Mar 2014 13:07:02 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: Mike Snitzer <snitzer@redhat.com>
cc: Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org, "Alasdair G. Kergon" <agk@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: slab_common: fix the check for duplicate slab names
In-Reply-To: <20140325170324.GC580@redhat.com>
Message-ID: <alpine.DEB.2.10.1403251306260.26471@nuc>
References: <alpine.LRH.2.02.1403041711300.29476@file01.intranet.prod.int.rdu2.redhat.com> <20140325170324.GC580@redhat.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Mar 2014, Mike Snitzer wrote:

> This patch still isn't upstream.  Who should be shepherding it to Linus?

Pekka usually does that.

Acked-by: Christoph Lameter <cl@linux.com>
