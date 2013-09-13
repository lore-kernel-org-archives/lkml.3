Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab3IMTxh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 15:53:37 -0400
Received: from science.horizon.com ([71.41.210.146]:63687 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754096Ab3IMTxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 15:53:36 -0400
Date: 13 Sep 2013 15:53:35 -0400
Message-ID: <20130913195335.18955.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: joe@perches.com, keescook@chromium.org
Subject: Re: [PATCH] vsprintf: drop comment claiming %n is ignored
Cc: akpm@linux-foundation.org, dan.carpenter@oracle.com, davem@davemloft.net,
        eldad@fogrefinery.com, jbeulich@suse.com, jkosina@suse.cz,
        linux-kernel@vger.kernel.org, linux@horizon.com, rdunlap@infradead.org
In-Reply-To: <1378931312.4714.26.camel@joe-AO722>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Maybe WARN_ONCE so it's easier to emit the format too.

Good idea.  And, if it's not too much trouble, a comment explaining
why it's deliberately omitted so the issue doesn't arise again.
