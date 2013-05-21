Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071Ab3EUWCD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 18:02:03 -0400
Received: from mail-gh0-f181.google.com ([209.85.160.181]:56984 "EHLO
	mail-gh0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739Ab3EUWCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 18:02:02 -0400
Message-ID: <519BEED7.6030605@gmail.com>
Date: Tue, 21 May 2013 18:01:59 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Rafael Aquini <aquini@redhat.com>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>, Karel Zak <kzak@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, hughd@google.com, shli@kernel.org,
        jmoyer@redhat.com, riel@redhat.com, lwoodman@redhat.com,
        mgorman@suse.de
Subject: Re: [RFC PATCH 02/02] swapon: add "cluster-discard" support
References: <cover.1369092449.git.aquini@redhat.com> <398ace0dd3ca1283372b3aad3fceeee59f6897d7.1369084886.git.aquini@redhat.com> <519AC7B3.5060902@gmail.com> <20130521102648.GB11774@x2.net.home> <519BD640.4040102@gmail.com> <20130521211300.GE20178@optiplex.redhat.com>
In-Reply-To: <20130521211300.GE20178@optiplex.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Instead of reverting and renaming --discard, what about making it accept an
> optional argument, so we could use --discard (to enable all thing and keep
> backward compatibility); --discard=cluster & --discard=batch (or whatever we
> think it should be named). I'll try to sort this approach out if you folks think
> it's worthwhile. 

Optional argument looks nice, at least to me. 

But hmm.. 

"cluster" and "batch" describes current kernel implementation, not user visible effect. 
Usually I suggest to pick up a word from man pages because it describe user visible action.
e.g. --discard=freed-pages or --discard=io or --discard=swapon or --discard=once, etc..

But this is not strong opinion. You can ignore it. I don't think I have good English sense. :-)

