Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935AbaFROlX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 10:41:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:62913 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752303AbaFROlV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 10:41:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,501,1400050800"; 
   d="scan'208";a="559592387"
Message-ID: <53A1A509.4080802@intel.com>
Date: Wed, 18 Jun 2014 07:41:13 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Qiaowei Ren <qiaowei.ren@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org,
        Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH v6 00/10] Intel MPX support
References: <1403084656-27284-1-git-send-email-qiaowei.ren@intel.com>
In-Reply-To: <1403084656-27284-1-git-send-email-qiaowei.ren@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2014 02:44 AM, Qiaowei Ren wrote:
> This patchset adds support for the Memory Protection Extensions
> (MPX) feature found in future Intel processors.

It's very important to note that this is a very different patch set than
the last one.  The way we are freeing the unused bounds tables is
_completely different (9/10), and needs some very heavy mm reviews.  I'm
sure Qiaowei will cc linux-mm@ next time.

We're also not asking that this be merged in its current state.  The
32-bit binary on 64-bit kernel issue is a show stopper for merging, but
we're trying to post early and often.
