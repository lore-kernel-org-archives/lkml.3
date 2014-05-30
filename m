Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965381AbaE3PrT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 11:47:19 -0400
Received: from mail.kernel.org ([198.145.19.201]:47669 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965326AbaE3PrP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 11:47:15 -0400
Date: Fri, 30 May 2014 12:47:09 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Jean Delvare <jdelvare@suse.de>, zhangdianfang <zhangdianfang@huawei.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        David Binderman <dcb314@hotmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] toosl/perf: convert "==" into "="
Message-ID: <20140530154709.GC1202@kernel.org>
References: <5387D6A6.20703@huawei.com>
 <20140530144446.1b4586f5@endymion.delvare>
 <20140530152011.GA1202@kernel.org>
 <20140530153729.GE7427@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="4Ckj6UjgE2iN1+kY"
Content-Disposition: inline
In-Reply-To: <20140530153729.GE7427@krava.brq.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Em Fri, May 30, 2014 at 05:37:29PM +0200, Jiri Olsa escreveu:
> On Fri, May 30, 2014 at 12:20:11PM -0300, Arnaldo Carvalho de Melo wrote:
> > Em Fri, May 30, 2014 at 02:44:46PM +0200, Jean Delvare escreveu:
> > > I don't have anything to do with this, I'm not the author of the code
> > > nor the maintainer and I don't know anything about it. Arnaldo Carvalho
> > > de Melo is the right person to handle this bug.
> > 
> > Jiri,

> > 	Please take this patch, you can stick my:

> > Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>

> sure, but I dont see the patch on the lkml.. any chance of resend?
 
> I guess I could dig the patch from above.. if you confirm it's
> the only change ;-)

Hey, no need to go to such great lenghts, submitters must try and make
it easier to maintainers! :-)

Find it attached, zhangdianfang, please send it as an attachment next
time, also please CC lkml as well.

Thanks,

- Arnaldo

--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="ui_browser.patch"

>From acme  Thu May 29 22:31:47 2014
Delivered-To: arnaldo.melo@gmail.com
Received: from gmail-imap.l.google.com [74.125.131.109]
	by zoo.ghostprotocols.net with IMAP (fetchmail-6.3.26)
	for <acme@localhost> (single-drop); Thu, 29 May 2014 22:31:47 -0300 (BRT)
Received: by 10.170.63.135 with SMTP id f129csp73227ykf; Thu, 29 May 2014
 17:54:50 -0700 (PDT)
X-Received: by 10.66.148.98 with SMTP id tr2mr13825805pab.33.1401411289441;
 Thu, 29 May 2014 17:54:49 -0700 (PDT)
Return-Path: <zhangdianfang@huawei.com>
Received: from mail.kernel.org (mail.kernel.org. [198.145.19.201]) by
 mx.google.com with ESMTP id we6si3163030pac.143.2014.05.29.17.54.49 for
 <arnaldo.melo@gmail.com>; Thu, 29 May 2014 17:54:49 -0700 (PDT)
Received-SPF: softfail (google.com: domain of transitioning
 zhangdianfang@huawei.com does not designate 198.145.19.201 as permitted
 sender) client-ip=198.145.19.201;
Authentication-Results: mx.google.com; spf=softfail (google.com: domain of
 transitioning zhangdianfang@huawei.com does not designate 198.145.19.201 as
 permitted sender) smtp.mail=zhangdianfang@huawei.com
Received: by mail.kernel.org (Postfix) id E533120142; Fri, 30 May 2014
 00:54:48 +0000 (UTC)
Delivered-To: acme@kernel.org
Received: from mail.kernel.org (localhost [127.0.0.1]) by mail.kernel.org
 (Postfix) with ESMTP id 3937E2035E for <acme@kernel.org>; Fri, 30 May 2014
 00:54:48 +0000 (UTC)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [119.145.14.66])
 (using TLSv1 with cipher DES-CBC3-SHA (168/168 bits)) (No client certificate
 requested) by mail.kernel.org (Postfix) with ESMTPS id 88E0D20142 for
 <acme@kernel.org>; Fri, 30 May 2014 00:54:43 +0000 (UTC)
Received: from 172.24.2.119 (EHLO szxeml207-edg.china.huawei.com)
 ([172.24.2.119]) by szxrg03-dlp.huawei.com (MOS 4.4.3-GA FastPath queued)
 with ESMTP id API05293; Fri, 30 May 2014 08:54:04 +0800 (CST)
Received: from SZXEML422-HUB.china.huawei.com (10.82.67.161) by
 szxeml207-edg.china.huawei.com (172.24.2.56) with Microsoft SMTP Server (TLS)
 id 14.3.158.1; Fri, 30 May 2014 08:54:02 +0800
Received: from [127.0.0.1] (10.177.27.190) by szxeml422-hub.china.huawei.com
 (10.82.67.161) with Microsoft SMTP Server id 14.3.158.1; Fri, 30 May 2014
 08:53:59 +0800
Message-ID: <5387D6A6.20703@huawei.com>
Date: Fri, 30 May 2014 08:53:58 +0800
From: zhangdianfang <zhangdianfang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509
 Thunderbird/17.0.6
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo
 Carvalho de Melo <acme@kernel.org>, David Binderman <dcb314@hotmail.com>,
 Jean Delvare <jdelvare@suse.de>
Subject: [PATCH] toosl/perf: convert "==" into "="
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.190]
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
 RP_MATCHES_RCVD,UNPARSEABLE_RELAY autolearn=unavailable version=3.3.1
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on mail.kernel.org
X-Virus-Scanned: ClamAV using ClamSMTP
Status: RO

convert "==" into "="

Bug description: https://bugzilla.kernel.org/show_bug.cgi?id=76751

Cc: Jean Delvare <jdelvare@suse.de>
Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Dianfang Zhang <zhangdianfang@huawei.com>
---
 tools/perf/ui/browser.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/ui/browser.c b/tools/perf/ui/browser.c
index d11541d..3ccf6e1 100644
--- a/tools/perf/ui/browser.c
+++ b/tools/perf/ui/browser.c
@@ -194,7 +194,7 @@ int ui_browser__warning(struct ui_browser *browser, int timeout,
 		ui_helpline__vpush(format, args);
 		va_end(args);
 	} else {
-		while ((key == ui__question_window("Warning!", text,
+		while ((key = ui__question_window("Warning!", text,
 						   "Press any key...",
 						   timeout)) == K_RESIZE)
 			ui_browser__handle_resize(browser);
-- 
1.7.1


--4Ckj6UjgE2iN1+kY--
