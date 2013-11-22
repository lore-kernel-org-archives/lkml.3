Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114Ab3KVU3d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 15:29:33 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35765 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477Ab3KVU3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 15:29:32 -0500
Message-ID: <528FBEA7.4080403@jp.fujitsu.com>
Date: Fri, 22 Nov 2013 15:29:27 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: oleg@redhat.com, akpm@linux-foundation.org
CC: kosaki.motohiro@jp.fujitsu.com, viro@ZenIV.linux.org.uk,
        keescook@chromium.org, mhocko@suse.cz, snanda@chromium.org,
        dserrg@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] exec: move the final allow_write_access/fput into
 free_bprm()
References: <20131122175445.GA31456@redhat.com>
In-Reply-To: <20131122175445.GA31456@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(11/22/2013 12:54 PM), Oleg Nesterov wrote:
> Both success/failure paths cleanup bprm->file, we can move this
> code into free_bprm() to simlify and cleanup this logic.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


