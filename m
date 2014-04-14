Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060AbaDNQXU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:23:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47724 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753913AbaDNQXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:23:18 -0400
Message-ID: <534C0B6C.8070109@zytor.com>
Date: Mon, 14 Apr 2014 09:23:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Chen, Gong" <gong.chen@linux.intel.com>, tony.luck@intel.com
CC: tglx@linutronix.de, mingo@kernel.org, linux-kernel@vger.kernel.org,
        linux-tip-commits@vger.kernel.org
Subject: Re: [PATCH 2/2] x86, MCE: Cleanup macro __get_cpu_var
References: <tip-27f6c573e0f77f7d1cc907c1494c99a61e48b7d8@git.kernel.org> <1397464777-25451-1-git-send-email-gong.chen@linux.intel.com> <1397464777-25451-2-git-send-email-gong.chen@linux.intel.com>
In-Reply-To: <1397464777-25451-2-git-send-email-gong.chen@linux.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please read Documentation/this_cpu_ops.txt for reference for how to use
these functions.  However, you want to avoid forming a pointer if you
can; it is relatively expensive to do so.

	-hpa

