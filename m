Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760837Ab3DBGnu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 02:43:50 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:51986 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759919Ab3DBGns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 02:43:48 -0400
MIME-Version: 1.0
In-Reply-To: <20130319051045.GB8858@lge.com>
References: <1358755287-3899-1-git-send-email-iamjoonsoo.kim@lge.com>
	<20130319051045.GB8858@lge.com>
Date: Tue, 2 Apr 2013 09:43:47 +0300
X-Google-Sender-Auth: f1ebMoq1OQ5Ph8eKnGbMZE5AeZc
Message-ID: <CAOJsxLH7Vhi1ady+uu5Vn-o5bW4rd6MiJZ1Okjqo2nX-JjgXAQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] slub: correct to calculate num of acquired objects
 in get_partial_node()
From: Pekka Enberg <penberg@kernel.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 7:10 AM, Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> Could you pick up 1/3, 3/3?
> These are already acked by Christoph.
> 2/3 is same effect as Glauber's "slub: correctly bootstrap boot caches",
> so should skip it.

Applied, thanks!
