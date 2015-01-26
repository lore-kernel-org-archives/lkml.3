Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332AbbAZPDo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 10:03:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41811 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244AbbAZPDn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 10:03:43 -0500
Date: Mon, 26 Jan 2015 16:00:06 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Wang Nan <wangnan0@huawei.com>
Cc: jeremie.galarneau@efficios.com, rostedt@goodmis.org,
        alexmonthy@voxpopuli.im, bigeasy@linutronix.de, lizefan@huawei.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] perf: convert to ctf: support converting
 syscalls:* tracepoints.
Message-ID: <20150126150006.GB2122@krava.brq.redhat.com>
References: <1422268705-32084-1-git-send-email-wangnan0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422268705-32084-1-git-send-email-wangnan0@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 06:38:22PM +0800, Wang Nan wrote:
> Babeltrace now support bt_ctf_validate_identifier() to allow us detect
> keyword confliction before real add it. I update patch 2/3 to use that
> new interface. Also, I group all 3 patches I made during converting
> syscalls:* tracepoints samples together for review.
> 
> Wang Nan (3):
>   tools lib traceevent: add priv field to truct format_field.
>   perf: convert: fix duplicate field names and avoid reserved keywords.
>   perf: convert: fix signess of value.

heya,
looks ok to me.. I applied/pushed this on the top fo my 'perf/core_ctf_convert'
branch and will repost together with CTF v4 post, once we figure out the:
  http://marc.info/?l=linux-kernel&m=142219345232713&w=2

and get feedback from Steven about the libtrace change ;-)

thanks,
jirka
