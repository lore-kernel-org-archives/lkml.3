Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbaHDT2e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 15:28:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42799 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752227AbaHDT2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 15:28:33 -0400
Date: Mon, 4 Aug 2014 21:26:41 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Aleksei Besogonov <alex.besogonov@gmail.com>
Cc: David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org
Subject: Re: Soft lockups during reading /proc/PID/smaps
Message-ID: <20140804192641.GA23739@redhat.com>
References: <loom.20140731T091947-310@post.gmane.org> <alpine.DEB.2.02.1407310041500.20816@chino.kir.corp.google.com> <117A54C0-F3AC-4DD0-B2F6-886C5D4419E3@gmail.com> <20140802181958.GA28283@redhat.com> <264016DC-6B8B-4732-8977-44AA2CF47E1A@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <264016DC-6B8B-4732-8977-44AA2CF47E1A@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03, Aleksei Besogonov wrote:
>
> Thanks, it works on the rc7 kernel.

Great!

I didn't have time today, will write the changelog and send the patch
tomorrow.

Thanks a lot Aleksei.

Oleg.

