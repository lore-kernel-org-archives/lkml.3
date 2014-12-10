Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758065AbaLJQRO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 11:17:14 -0500
Received: from resqmta-po-08v.sys.comcast.net ([96.114.154.167]:48422 "EHLO
	resqmta-po-08v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752416AbaLJQRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 11:17:12 -0500
Date: Wed, 10 Dec 2014 10:17:10 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Jesper Dangaard Brouer <brouer@redhat.com>
cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-api@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] Faster than SLAB caching of SKBs with qmempool
 (backed by alf_queue)
In-Reply-To: <20141210163321.0e4e4fd2@redhat.com>
Message-ID: <alpine.DEB.2.11.1412101016400.4657@gentwo.org>
References: <20141210033902.2114.68658.stgit@ahduyck-vm-fedora20> <20141210141332.31779.56391.stgit@dragon> <alpine.DEB.2.11.1412100917020.4047@gentwo.org> <20141210163321.0e4e4fd2@redhat.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Dec 2014, Jesper Dangaard Brouer wrote:

> That is very strange! I did notice that it was somehow delayed in
> showing up on gmane.org (http://thread.gmane.org/gmane.linux.network/342347/focus=126148)
> and didn't show up on netdev either...

It finally got through.

