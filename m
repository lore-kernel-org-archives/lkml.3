Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593AbaIYDA3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 23:00:29 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:42632 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbaIYDA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 23:00:28 -0400
Message-ID: <1411614023.5206.35.camel@marge.simpson.net>
Subject: Re: [PATCH 0/2] sched: deferred set priority (dprio)
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Sergey Oboguev <oboguev.public@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com,
        Peter Zijlstra <peterz@infradead.org>
Date: Thu, 25 Sep 2014 05:00:23 +0200
In-Reply-To: <CA+80gGbnSVpbG11PPPLPZzt_jEvZSchDnU-K+yc1tSe1S=HKKA@mail.gmail.com>
References: <CA+80gGbnSVpbG11PPPLPZzt_jEvZSchDnU-K+yc1tSe1S=HKKA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-09-24 at 12:29 -0700, Sergey Oboguev wrote:

> Message 1/2 contains the patch to the kernel tree (3.16.3).
> Message 2/2 contains the patch for man pages tree.

Peter/Ingo are unlikely to ship this off to @stable.  If you want this
to get off the ground, you'll need to submit against tip or master.

-Mike

(not that I want that to happen mind you, I would still like to see
dprio buried under a large rock with a stake through it's vile heart)

