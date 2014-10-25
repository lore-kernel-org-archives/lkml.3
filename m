Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753AbaJYDRM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 23:17:12 -0400
Received: from plane.gmane.org ([80.91.229.3]:48563 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102AbaJYDRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 23:17:10 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?UTF-8?B?RMOibmllbA==?= Fraga <fragabr@gmail.com>
Subject: Re: rcu_preempt detected stalls.
Date: Sat, 25 Oct 2014 01:16:55 -0200
Organization: http://www.youtube.com/DanielFragaBR
Message-ID: <m2f4nb$dgo$1@ger.gmane.org>
References: <20141013173504.GA27955@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 179.99.48.34
X-Newsreader: Claws Mail 3.10.1-149-g7d0fc8 (GTK+ 2.24.24; x86_64-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Oct 2014 13:35:04 -0400
Dave Jones <davej@redhat.com> wrote:

> Today in "rcu stall while fuzzing" news:

	My bug report seems to be related with this topic:

Regression: kernel 3.17 halts sometimes (with Call trace)

https://bugzilla.kernel.org/show_bug.cgi?id=85941

	Could somone take a look?

	Thanks.

-- 
Linux 3.16.0-00115-g19583ca: Shuffling Zombie Juror
http://www.youtube.com/DanielFragaBR
http://exchangewar.info
Bitcoin: 12H6661yoLDUZaYPdah6urZS5WiXwTAUgL


