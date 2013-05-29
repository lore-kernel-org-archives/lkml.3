Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965858Ab3E2SsN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 14:48:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4280 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965293Ab3E2SsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 14:48:08 -0400
X-Authority-Analysis: v=2.0 cv=L+efspv8 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=1sJjQSHRGgwA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=Tt5UUStIjKEA:10 a=20KFwNOVAAAA:8 a=UOwcBvfhCd8n4lT6AtMA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1369853285.15552.72.camel@gandalf.local.home>
Subject: Re: [PATCH trace-cmd 2/2] git-housekeeping: Add the .gitattributes
 file
From: Steven Rostedt <rostedt@goodmis.org>
To: John Kacur <jkacur@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Date: Wed, 29 May 2013 14:48:05 -0400
In-Reply-To: <1369844328-30582-2-git-send-email-jkacur@redhat.com>
References: <1369844328-30582-1-git-send-email-jkacur@redhat.com>
	 <1369844328-30582-2-git-send-email-jkacur@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-29 at 18:18 +0200, John Kacur wrote:
> By adding the .gitattributes file, git-archive can be informed not to
> includes files such as .gitignore and ironically .gitattributes
> 
> Signed-off-by: John Kacur <jkacur@redhat.com>

Thanks John, I'll pick these up.

-- Steve

> ---
>  .gitattributes | 2 ++
>  1 file changed, 2 insertions(+)
>  create mode 100644 .gitattributes
> 
> diff --git a/.gitattributes b/.gitattributes
> new file mode 100644
> index 0000000..5966153
> --- /dev/null
> +++ b/.gitattributes
> @@ -0,0 +1,2 @@
> +.gitattributes export-ignore
> +.gitignore export-ignore


