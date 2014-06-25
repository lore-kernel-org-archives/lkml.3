Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331AbaFYQTI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 12:19:08 -0400
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:40854 "EHLO
	qmta05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756853AbaFYQTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 12:19:07 -0400
Date: Wed, 25 Jun 2014 11:19:02 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Vladimir Davydov <vdavydov@parallels.com>
cc: akpm@linux-foundation.org, iamjoonsoo.kim@lge.com, rientjes@google.com,
        penberg@kernel.org, hannes@cmpxchg.org, mhocko@suse.cz,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] slab: document why cache can have no per cpu array on
 kfree
In-Reply-To: <1403707177-3740-1-git-send-email-vdavydov@parallels.com>
Message-ID: <alpine.DEB.2.11.1406251118440.26523@gentwo.org>
References: <20140624073840.GC4836@js1304-P5Q-DELUXE> <1403707177-3740-1-git-send-email-vdavydov@parallels.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Acked-by: Christoph Lameter <cl@linux.com>

