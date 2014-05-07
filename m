Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933213AbaEGOY1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 10:24:27 -0400
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:52107 "EHLO
	qmta10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932405AbaEGOYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 10:24:25 -0400
Date: Wed, 7 May 2014 09:24:23 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>
Subject: Re: [PATCH v2 10/10] slab: remove BAD_ALIEN_MAGIC
In-Reply-To: <1399442780-28748-11-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <alpine.DEB.2.10.1405070924070.12543@gentwo.org>
References: <1399442780-28748-1-git-send-email-iamjoonsoo.kim@lge.com> <1399442780-28748-11-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2014, Joonsoo Kim wrote:

> BAD_ALIEN_MAGIC value isn't used anymore. So remove it.

Acked-by: Christoph Lameter <cl@linux.com>
