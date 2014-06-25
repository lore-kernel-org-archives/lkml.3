Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757070AbaFYOTd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 10:19:33 -0400
Received: from forward-corp1e.mail.yandex.net ([77.88.60.199]:57974 "EHLO
	forward-corp1e.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756775AbaFYOTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 10:19:31 -0400
X-Yandex-Uniq: 3d045346-ea7e-446a-b55d-9500513b310d
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Date: Wed, 25 Jun 2014 18:19:22 +0400
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@kernel.org, namhyung@kernel.org, artagnon@gmail.com,
        rusty@rustcorp.com.au, bp@suse.de
Subject: Re: [PATCH v4 0/4] perf timechart io mode
Message-ID: <20140625141922.GE21788@stfomichev-desktop.yandex.net>
References: <1403260191-10079-1-git-send-email-stfomichev@yandex-team.ru>
 <20140624084113.GC31390@krava.redhat.com>
 <20140624091022.GE20225@stfomichev-desktop.yandex.net>
 <20140624165712.GA10114@stfomichev-desktop.yandex.net>
 <53A9B7A4.9050805@gmail.com>
 <20140624185134.GB1148@krava.brq.redhat.com>
 <53A9CB6E.5080104@gmail.com>
 <20140625112019.GC21788@stfomichev-desktop.yandex.net>
 <53AAD62D.3030105@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53AAD62D.3030105@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If the event type does not make sense how can you trust any other field --
> like event size?
I don't mean corruption like this. I mean if event ordering is wrong or
some event occurs in unexpected place we may just be tolerant and skip
it with a warning.
