Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbaDNRCh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 13:02:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48199 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755156AbaDNRCf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 13:02:35 -0400
Message-ID: <534C148B.30005@zytor.com>
Date: Mon, 14 Apr 2014 10:02:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "K. Y. Srinivasan" <kys@microsoft.com>, x86@kernel.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, tglx@linutronix.de, JBeulich@suse.com
Subject: Re: [PATCH V3 1/1] X86: Probe for PIC and set legacy_pic appropriately
References: <1397497584-23717-1-git-send-email-kys@microsoft.com>
In-Reply-To: <1397497584-23717-1-git-send-email-kys@microsoft.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2014 10:46 AM, K. Y. Srinivasan wrote:
> This patch implements the proposal put forth by H. Peter Anvin <hpa@linux.intel.com>.
> 
> In  version V1 of the patch, I had cleaned up the code based on comments from Peter.
> In  version V2 of the patch, I have addressed additional comments from Peter.
> In this version of the patch, I have addressed Jan's comments (JBeulich@suse.com).
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

Technically the patch looks good, but I'm going to have to reject it
based on the patch description.

Keep in mind that the above description is the only thing that would go
into the git repository, and needs to be understandable to someone, say,
10 years from now.

The above says nothing about what the proposal was, and the motivation,
and the problems it addresses.  So the patch is good, but please write a
proper, standalone description for it.

Thanks,

	-hpa


