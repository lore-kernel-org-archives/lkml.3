Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbaBETaH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 14:30:07 -0500
Received: from qmta09.westchester.pa.mail.comcast.net ([76.96.62.96]:54352
	"EHLO qmta09.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751559AbaBETaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 14:30:04 -0500
Date: Wed, 5 Feb 2014 13:30:01 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: David Rientjes <rientjes@google.com>
cc: Vladimir Davydov <vdavydov@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] slub: fix false-positive lockdep warning in
 free_partial()
In-Reply-To: <alpine.DEB.2.02.1402050022030.7839@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.10.1402051329450.21661@nuc>
References: <52F1F25F.20402@parallels.com> <1391588133-15469-1-git-send-email-vdavydov@parallels.com> <alpine.DEB.2.02.1402050022030.7839@chino.kir.corp.google.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Acked-by: Christoph Lameter <cl@linux.com>

