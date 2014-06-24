Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965124AbaFXRAX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 13:00:23 -0400
Received: from forward-corp1g.mail.yandex.net ([95.108.253.251]:44052 "EHLO
	forward-corp1g.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932151AbaFXRAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 13:00:22 -0400
X-Yandex-Uniq: 7dd882a4-4845-47d4-917a-d2040fa130a9
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Date: Tue, 24 Jun 2014 21:00:12 +0400
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: Jiri Olsa <jolsa@redhat.com>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@kernel.org, namhyung@kernel.org, artagnon@gmail.com,
        rusty@rustcorp.com.au, bp@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] perf timechart: implement IO mode
Message-ID: <20140624170012.GB10114@stfomichev-desktop.yandex.net>
References: <1403260191-10079-1-git-send-email-stfomichev@yandex-team.ru>
 <1403260191-10079-3-git-send-email-stfomichev@yandex-team.ru>
 <20140624083435.GA31390@krava.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140624083435.GA31390@krava.redhat.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'll need some more info (description, usage..) to push this throught
There is actual description and usage example in the documentation, does
this count? Or you want me to also have some small explanation in the
changelog?
