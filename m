Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750AbaEBGNo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 02:13:44 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:48827 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbaEBGNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 02:13:43 -0400
Message-ID: <1399011219.5233.55.camel@marge.simpson.net>
Subject: Re: [PATCH RFC/TEST] sched: make sync affine wakeups work
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, morten.rasmussen@arm.com, mingo@kernel.org,
        peterz@infradead.org, george.mccollister@gmail.com,
        ktkhai@parallels.com
Date: Fri, 02 May 2014 08:13:39 +0200
In-Reply-To: <20140502004237.79dd3de6@annuminas.surriel.com>
References: <20140502004237.79dd3de6@annuminas.surriel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-05-02 at 00:42 -0400, Rik van Riel wrote:

> Whether or not this is the right thing to do remains to be seen,
> but it does allow us to verify whether or not the wake_affine
> strategy of always doing affine wakeups and only disabling them
> in a specific circumstance is sound, or needs rethinking...

Yes, it needs rethinking.

I know why you want to try this, yes, select_idle_sibling() is very much
a two faced little bitch.  NOHZ doesn't help, my kernels throttle it.

-Mike


