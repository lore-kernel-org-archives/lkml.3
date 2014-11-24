Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096AbaKXRRZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 12:17:25 -0500
Received: from resqmta-po-09v.sys.comcast.net ([96.114.154.168]:37168 "EHLO
	resqmta-po-09v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752057AbaKXRRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 12:17:24 -0500
Date: Mon, 24 Nov 2014 11:17:22 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Min-Hua Chen <orca.chen@gmail.com>
cc: Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org
Subject: Re: [PATCH] slub: fix confusing error messages in check_slab
In-Reply-To: <CAHkaATSEn9WMKJNRp5QvzPsno_vddtMXY39yvi=BGtb4M+Hqdw@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1411241117030.8951@gentwo.org>
References: <CAHkaATSEn9WMKJNRp5QvzPsno_vddtMXY39yvi=BGtb4M+Hqdw@mail.gmail.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Nov 2014, Min-Hua Chen wrote:

> In check_slab, s->name is passed incorrectly to the error
> messages. It will cause confusing error messages if the object
> check fails. This patch fix this bug by removing s->name.

I have seen a patch like thios before.

Acked-by: Christoph Lameter <cl@linux.com>
