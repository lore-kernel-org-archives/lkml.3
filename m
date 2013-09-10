Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111Ab3IJIYg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 04:24:36 -0400
Received: from science.horizon.com ([71.41.210.146]:49016 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754904Ab3IJIYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 04:24:30 -0400
Date: 10 Sep 2013 04:24:27 -0400
Message-ID: <20130910082427.18481.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, viro@ZenIV.linux.org.uk
Subject: Re: [PATCH v4 1/1] dcache: Translating dentry into pathname without taking rename_lock
Cc: aswin@hp.com, john@stoffel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, scott.norton@hp.com,
        torvalds@linux-foundation.org, Waiman.Long@hp.com
In-Reply-To: <20130910005754.GV13318@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> _What_ "pathname translations"?  Pathname resolution doesn't fall back to
> seq_writelock() at all.

I meant the translation of dentry to pathname that this thread is about.
Apologies for my confusing abbreviation.  Since the reverse translation
(pathname to dentry) is done a level at a time and people understand
that it's not atomic, I agree with Linus that a livelock there is too
remote a possibility to worry about.
