Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020Ab3EaPNn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 11:13:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59049 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753707Ab3EaPNe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 11:13:34 -0400
Message-ID: <51A8BE05.7060008@zytor.com>
Date: Fri, 31 May 2013 08:13:09 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Jacob Shin <jacob.shin@amd.com>
CC: Borislav Petkov <bp@alien8.de>, mingo@kernel.org,
        linux-kernel@vger.kernel.org, fenghua.yu@intel.com, tglx@linutronix.de,
        hpa@linux.intel.com, linux-tip-commits@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [tip:x86/microcode] x86, microcode, amd: Early microcode patch
 loading support for AMD
References: <1369940959-2077-5-git-send-email-jacob.shin@amd.com> <tip-757885e94a22bcc82beb9b1445c95218cb20ceab@git.kernel.org> <20130531084133.GA14076@nazgul.tnic> <20130531150241.GA12006@jshin-Toonie>
In-Reply-To: <20130531150241.GA12006@jshin-Toonie>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If you send a patch with text above the patch, please include a scissor
line:

---8<---

... above the patch so that git tools can process it.

	-hpa
