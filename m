Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965480AbaFTJTo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 05:19:44 -0400
Received: from forward-corp1f.mail.yandex.net ([95.108.130.40]:36294 "EHLO
	forward-corp1f.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933271AbaFTJTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 05:19:43 -0400
X-Yandex-Uniq: 826b74e1-ebbf-489a-ac74-396b058dfdef
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Date: Fri, 20 Jun 2014 13:19:34 +0400
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: Namhyung Kim <namhyung@kernel.org>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@kernel.org, artagnon@gmail.com, jolsa@redhat.com,
        rusty@rustcorp.com.au, bp@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] perf timechart: implement IO mode
Message-ID: <20140620091934.GJ15620@stfomichev-desktop.yandex.net>
References: <1403180583-12309-1-git-send-email-stfomichev@yandex-team.ru>
 <1403180583-12309-2-git-send-email-stfomichev@yandex-team.ru>
 <87egyk75nu.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87egyk75nu.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It (and others below) should be 'rec_argc -= 4' - i.e. I still see the
> segfault. :)
Damn, stupid me.

> Looks like this change should be applied to the exsting (for cpu and
> power events) boxes too.  Care to send it as a separate fix?
Yes, will add it as a first patch to the series, so it can be pulled
without the whole series if it still has some bugs.

> It seems you missed the change above (s/4.8f/.8f/g). :)
Thanks, will do it in the context of a distinct patch.
