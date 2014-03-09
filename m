Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371AbaCIHIT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 03:08:19 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:64192 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbaCIHIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 03:08:18 -0400
Date: Sun, 9 Mar 2014 09:08:11 +0200
From: Muli Ben-Yehuda <muli@cs.technion.ac.il>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: WANG Chao <chaowang@redhat.com>, "Jon D. Mason" <jdmason@kudzu.us>,
        "H. Peter Anvin" <hpa@zytor.com>, Baoquan He <bhe@redhat.com>,
        kexec@lists.infradead.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, calgary: use 8M TCE table size by default
Message-ID: <20140309070811.GB2525@needle>
References: <1394179816-15435-1-git-send-email-chaowang@redhat.com>
 <20140307141413.GF1326@redhat.com>
 <20140307155204.GC30641@dhcp-17-89.nay.redhat.com>
 <20140307160906.GH1326@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140307160906.GH1326@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2014 at 11:09:06AM -0500, Vivek Goyal wrote:

> I would say it is not very complicated to maintain backward
> compatibility in this case. So let us keep saved_max_pfn for some
> time and make kexec-tools changes. Some time down the line, one can
> get rid of saved_max_pfn completely.

If this is not too painful then this would be my preference too.

Cheers,
Muli
