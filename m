Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000AbaA2H3O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 02:29:14 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:36761 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbaA2H3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 02:29:12 -0500
Date: Tue, 28 Jan 2014 23:29:10 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: SeongJae Park <sj38.park@gmail.com>
cc: Greg KH <gregkh@linuxfoundation.org>,
        Mike Turquette <mturquette@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] clk: export __clk_get_hw for re-use in others
In-Reply-To: <CAEjAshrxXLJ-zFsTO9TnewYBBEPzFR1cixbLnD6U-U1EKdByxg@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1401282328360.10321@chino.kir.corp.google.com>
References: <1390110907-29918-1-git-send-email-sj38.park@gmail.com> <20140119173712.GA26481@kroah.com> <CAPtuhTikj38yKy-=uF7O+VFG_N4AWee23f9woemM318fM3V4VQ@mail.gmail.com> <CAEjAshoh5ucPJA6pG1sx+7HGCYjHzCKtbzmH+GYJwpefDYLwJg@mail.gmail.com>
 <CAEjAshozB4S0ZGqEn41ROfZwGTV+_GZRRTZ8cssi0VdH8Uhr_w@mail.gmail.com> <20140122045937.GB23869@kroah.com> <CAEjAshrxXLJ-zFsTO9TnewYBBEPzFR1cixbLnD6U-U1EKdByxg@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jan 2014, SeongJae Park wrote:

> Oops, I've forgot about the merge window. Thank you very much for your
> kind answer.
> Sorry if I bothered you while you're in busy time.
> Because the build problem is not a big deal because it exists only in
> -next tree,

This problem exists in Linus's tree, not only in -next.
