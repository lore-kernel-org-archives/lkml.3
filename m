Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499Ab3FYBCe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 21:02:34 -0400
Received: from one.firstfloor.org ([193.170.194.197]:58537 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591Ab3FYBCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 21:02:32 -0400
Date: Tue, 25 Jun 2013 03:02:31 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@kernel.org, hpa@zytor.com,
        paulus@samba.org, eranian@google.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf sort: Separate out memory-specific sort
 keys
Message-ID: <20130625010231.GV6123@two.firstfloor.org>
References: <1364991979-3008-3-git-send-email-namhyung@kernel.org>
 <tip-afab87b91f3f331d55664172dad8e476e6ffca9d@git.kernel.org>
 <20130625003010.GU6123@two.firstfloor.org>
 <51C8EBB5.3040000@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51C8EBB5.3040000@lge.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm not sure it should move to the common keys as normal perf
> session won't have those.  

Why not? If I enable weight sampling i get weights perfectly
fine in any session using the right PEBS events.

> I guess you need to set up a couple of
> TSX-specific sort keys like perf mem, if so what about moving the
> two weights to your table?

There's no TSX table and no separate perf TSX session.
It's just some additional attributes.

-Andi
