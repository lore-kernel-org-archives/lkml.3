Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015AbaE3Odh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 10:33:37 -0400
Received: from qmta14.emeryville.ca.mail.comcast.net ([76.96.27.212]:47117
	"EHLO qmta14.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753504AbaE3Odg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 10:33:36 -0400
Date: Fri, 30 May 2014 09:33:33 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Vladimir Davydov <vdavydov@parallels.com>
cc: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@suse.cz,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH -mm 3/8] memcg: mark caches that belong to offline memcgs
 as dead
In-Reply-To: <2cb0d48c06a57586606deec0e368b4a3ecbc0b91.1401457502.git.vdavydov@parallels.com>
Message-ID: <alpine.DEB.2.10.1405300933190.11943@gentwo.org>
References: <cover.1401457502.git.vdavydov@parallels.com> <2cb0d48c06a57586606deec0e368b4a3ecbc0b91.1401457502.git.vdavydov@parallels.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 May 2014, Vladimir Davydov wrote:

> This will be used by the next patches.

Acked-by: Christoph Lameter <cl@linux.com>
