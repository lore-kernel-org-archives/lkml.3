Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768AbaFWUAQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 16:00:16 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:47111 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812AbaFWUAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 16:00:14 -0400
From: Andy Lutomirski <luto@amacapital.net>
X-Google-Original-From: Andy Lutomirski <luto@mit.edu>
Message-ID: <53A8874A.3050301@mit.edu>
Date: Mon, 23 Jun 2014 13:00:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Qiaowei Ren <qiaowei.ren@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 08/10] x86, mpx: add prctl commands PR_MPX_REGISTER,
 PR_MPX_UNREGISTER
References: <1403084656-27284-1-git-send-email-qiaowei.ren@intel.com> <1403084656-27284-9-git-send-email-qiaowei.ren@intel.com>
In-Reply-To: <1403084656-27284-9-git-send-email-qiaowei.ren@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2014 02:44 AM, Qiaowei Ren wrote:
> This patch adds the PR_MPX_REGISTER and PR_MPX_UNREGISTER prctl()
> commands. These commands can be used to register and unregister MPX
> related resource on the x86 platform.
> 
> The base of the bounds directory is set into mm_struct during
> PR_MPX_REGISTER command execution. This member can be used to
> check whether one application is mpx enabled.

The register and unregister operations seem to be almost the same thing.
 How about just PR_SYNC_MPX?

Also, would this make more sense in arch_prctl?

--Andy
