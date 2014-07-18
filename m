Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761996AbaGROUc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 10:20:32 -0400
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:52824 "EHLO
	qmta03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761268AbaGROUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 10:20:31 -0400
Date: Fri, 18 Jul 2014 09:20:24 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: poma <pomidorabelisima@gmail.com>
cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Mailing-List fedora-kernel <kernel@lists.fedoraproject.org>
Subject: Re: WARNING: CPU: 1 PID: 495 at mm/slab_common.c:69
 kmem_cache_create+0x1a9/0x330()
In-Reply-To: <53C8FD95.5020302@gmail.com>
Message-ID: <alpine.DEB.2.11.1407180916340.28061@gentwo.org>
References: <53C8DF7F.5060707@gmail.com> <53C8FD95.5020302@gmail.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jul 2014, poma wrote:

> I guess someone working over the summertime. :)

Cache names should not contain blanks. I guess the

  WARN_ON(strchr(name, ' '));     /* It confuses parsers */

was triggered?

