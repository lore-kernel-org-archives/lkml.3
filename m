Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025Ab3LSR3d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 12:29:33 -0500
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:1621 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124Ab3LSR3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 12:29:31 -0500
Message-ID: <1387474151.2797.37.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH] ipc: change kern_ipc_perm.deleted type to bool
From: Davidlohr Bueso <davidlohr@hp.com>
To: Rafael Aquini <aquini@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Greg Thelen <gthelen@google.com>,
        Manfred Spraul <manfred@colorfullife.com>
Date: Thu, 19 Dec 2013 09:29:11 -0800
In-Reply-To: <2376eb01a06ca5e9ea68955f65ac1913929d41a1.1387416739.git.aquini@redhat.com>
References: <2376eb01a06ca5e9ea68955f65ac1913929d41a1.1387416739.git.aquini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-12-19 at 15:23 -0200, Rafael Aquini wrote:
> struct kern_ipc_perm.deleted is meant to be used as a boolean toogle, and
> the changes introduced by this patch are just to make the case explicit.
> 
> Signed-off-by: Rafael Aquini <aquini@redhat.com>

Acked-by: Davidlohr Bueso <davidlohr@hp.com>


