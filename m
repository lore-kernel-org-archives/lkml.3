Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127Ab3KVTmv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 14:42:51 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59248 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755657Ab3KVTmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 14:42:49 -0500
Message-ID: <528FB3B4.3030303@jp.fujitsu.com>
Date: Fri, 22 Nov 2013 14:42:44 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: oleg@redhat.com, akpm@linux-foundation.org
CC: kosaki.motohiro@jp.fujitsu.com, viro@ZenIV.linux.org.uk,
        keescook@chromium.org, mhocko@suse.cz, snanda@chromium.org,
        dserrg@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] check_unsafe_exec: use while_each_thread() rather
 than next_thread()
References: <20131122175439.GA31446@redhat.com>
In-Reply-To: <20131122175439.GA31446@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(11/22/2013 12:54 PM), Oleg Nesterov wrote:
> next_thread() should be avoided, change check_unsafe_exec()
> to use while_each_thread(). This also saves 32 bytes.

Just curious.
Why it should be avoided? Just for cleaner code? Or is there
serious issue?

